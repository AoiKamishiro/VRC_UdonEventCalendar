/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*/

using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Components.Video;
using VRC.SDK3.Video.Components;
using VRC.SDK3.Video.Components.Base;
using VRC.SDKBase;

namespace Kamishiro.VRChatUDON.EventCalendar
{
    [RequireComponent(typeof(VRCUnityVideoPlayer))]
    public class VideoPlayer : UdonSharpBehaviour
    {
        [SerializeField] private Button _LoadButton;
        [SerializeField] public BaseVRCVideoPlayer _VideoPlayer;
        [SerializeField] private RenderTexture _RenderTexture;
        [SerializeField] private VRCUrl _VRCUrl = VRCUrl.Empty;
        [SerializeField] private float _InitializeDelay = 10.0f;
        private const float _LoadCT = 6.0f;
        private bool _IsInCT = false;
        private const float RetryDeley = 10.0f;
        private const string InitializeError = "[<color=red>VRC Scroll Event Calendar</color>] VideoPlayer Initialization Failed. Please Check the UdonBehaviour.";
        private const string VdeoPlayerError = "[<color=red>VRC Scroll Event Calendar</color>] VideoPlayer Error. Reason: ";

        private void Start()
        {
            _LoadButton.interactable = false;

            if (_LoadButton == null ||
                  _VideoPlayer == null ||
                  _RenderTexture == null ||
                  _VRCUrl == VRCUrl.Empty)
            {
                Debug.LogError(InitializeError);
                this.enabled = false;
                return;
            }

            SendCustomEventDelayedSeconds(nameof(PlayVideo), _InitializeDelay);
        }
        public override void OnVideoError(VideoError videoError)
        {
            if (videoError == VideoError.RateLimited)
            {
                SendCustomEventDelayedSeconds(nameof(PlayVideo), RetryDeley);
            }
            else
            {
                Debug.LogError(VdeoPlayerError + videoError.ToString());
            }
        }
        public void PlayVideo()
        {
            _RenderTexture.Release();
            _VideoPlayer.PlayURL(_VRCUrl);
            SendCustomEvent(nameof(EnterCT));
            SendCustomEventDelayedSeconds(nameof(ExitCT), _LoadCT);
        }
        public void EnterCT()
        {
            _IsInCT = true;
            _LoadButton.interactable = false;
        }
        public void ExitCT()
        {
            _IsInCT = false;
            _LoadButton.interactable = true;
        }
        public void ReLoad()
        {
            if (!_IsInCT)
                SendCustomEvent(nameof(PlayVideo));
        }
    }
}

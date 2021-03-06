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
using VRC.SDKBase;

namespace Kamishiro.VRChatUDON.ScrollEventCalendar
{
    public class ScrollCalendar : UdonSharpBehaviour
    {
        [SerializeField] private Scrollbar scrollbar;
        [SerializeField] private RawImage calRawImage;
        [SerializeField] private Renderer calRenderer;
        [SerializeField] private Button button;
        [SerializeField] private VRCUnityVideoPlayer videoPlayer;
        [SerializeField] private RenderTexture renderTexture;
        [SerializeField] private VRCUrl url;
        [SerializeField] private string scrollParam = "_Scroll";
        [SerializeField] private float loadDelay = 15f;
        private float scrollValue = 0f;
        private const float coolTime = 6f;
        private float coolTimeTimer = 0f;
        [SerializeField] private float resetTime = 60;
        private float resetTimeTimer = 0f;
        private bool isWaiting = false;
        private bool isVideoPlaying = false;
        private bool initPlay = true;

        private void Start()
        {
            videoPlayer.enabled = false;
            button.interactable = false;
        }

        private void Update()
        {
            if (initPlay)
            {
                if (loadDelay >= 0f)
                {
                    loadDelay -= Time.deltaTime;
                }
                else
                {
                    videoPlayer.enabled = true;
                    SendCustomEvent(nameof(this.PlayVideo));
                    initPlay = false;
                }
            }
            if (isVideoPlaying)
            {
                if (coolTimeTimer >= 0f)
                {
                    coolTimeTimer -= Time.deltaTime;
                }
                else
                {
                    IsVideoPlaying(false);
                }
            }

            if (isWaiting)
            {
                if (resetTimeTimer >= 0f)
                {
                    resetTimeTimer -= Time.deltaTime;
                }
                else
                {
                    isWaiting = false;
                    ResetScrollValue();
                }
            }
        }

        public void SliderVaueChanged()
        {
            scrollValue = scrollbar.value;
            SetSliderValue();
            isWaiting = true;
            resetTimeTimer = resetTime;
        }
        public void ResetScrollValue()
        {
            scrollbar.value = 0f;
        }
        public void SetSliderValue()
        {
            if (calRawImage != null) { calRawImage.material.SetFloat(scrollParam, scrollValue); }
            if (calRenderer != null) { calRenderer.material.SetFloat(scrollParam, scrollValue); }
        }

        //Local (VideoPlayer)
        public void IsVideoPlaying(bool value)
        {
            isVideoPlaying = value;
            button.interactable = !value;
        }
        public void ReSync()
        {
            if (!isVideoPlaying)
            {
                PlayVideo();
            }
        }
        public void PlayVideo()
        {
            renderTexture.Release();
            videoPlayer.PlayURL(url);
            coolTimeTimer = coolTime;
            IsVideoPlaying(true);
        }
        public override void OnVideoReady()
        {
            Debug.Log("[<color=green>VRC Scroll Event Calendar</color>] OnVideoReady at \"" + transform.parent.name + "\".");
        }
        public override void OnVideoError(VideoError videoError)
        {
            Debug.Log("[<color=green>VRC Scroll Event Calendar</color>] OnVideoError at \"" + transform.parent.name + "\". Reason: " + videoError.ToString());
        }
        public override void OnVideoPlay()
        {
            Debug.Log("[<color=green>VRC Scroll Event Calendar</color>] OnVideoPlay at \"" + transform.parent.name + "\".");
        }
    }
}
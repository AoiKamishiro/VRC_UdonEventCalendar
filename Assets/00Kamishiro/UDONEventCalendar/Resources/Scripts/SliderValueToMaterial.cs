
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDKBase;
using VRC.Udon;

namespace Kamishiro.VRChatUDON.EventCalendar
{
    public class SliderValueToMaterial : UdonSharpBehaviour
    {
        [SerializeField] Image image;
        [SerializeField] string param;
        [SerializeField] Scrollbar slider;
        public void SetValue()
        {
            image.material.SetFloat(param, slider.value);
        }
    }
}
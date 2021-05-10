
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;
#if UNITY_EDITOR
using UnityEditor;
#endif

namespace Kamishiro.UnityEditor.EventCalendarHelper
{
    [ExecuteInEditMode]
    public class UDONEventCalendar : MonoBehaviour
    {
        [SerializeField] public bool useLighting = false;
        [SerializeField] public Material[] materials;
        [SerializeField] public float intensity = 0;
        [SerializeField] public string param = "_EmissiveIntensity";
        [SerializeField] Camera lightCamera;
        [SerializeField] Canvas canvas;
        public void Adjust()
        {
            if (transform.localScale.y == transform.localScale.z && transform.localScale.x != transform.localScale.y)
            {
                transform.localScale = new Vector3(transform.localScale.x, transform.localScale.x, transform.localScale.x);
            }
            else if (transform.localScale.x == transform.localScale.z && transform.localScale.y != transform.localScale.z)
            {
                transform.localScale = new Vector3(transform.localScale.y, transform.localScale.y, transform.localScale.y);
            }
            else if (transform.localScale.x == transform.localScale.y && transform.localScale.z != transform.localScale.x)
            {
                transform.localScale = new Vector3(transform.localScale.z, transform.localScale.z, transform.localScale.z);
            }
            else if (transform.localScale.x != transform.localScale.y && transform.localScale.y != transform.localScale.z)
            {
                transform.localScale = new Vector3(transform.localScale.x, transform.localScale.x, transform.localScale.x);
            }

            if (lightCamera == null)
                return;

            Vector3 scale = lightCamera.transform.lossyScale;
            lightCamera.orthographicSize = scale.x * 630.0f / 2.0f;
        }
        public void SetEmission()
        {
            if (string.IsNullOrWhiteSpace(param))
                return;

            if (materials.Length < 1)
                return;

            foreach (Material material in materials)
            {
                if (material != null)
                {
                    material.SetFloat(param, intensity);
                }
            }
        }
        public void SetMainCam()
        {
            if (gameObject.scene.name == null)
                return;

            if (canvas == null)
                return;

            if (canvas.worldCamera != null)
                return;

            Camera mCam = GameObject.FindGameObjectsWithTag("MainCamera")[0].GetComponent<Camera>();
            if (mCam == null)
                return;

            canvas.worldCamera = mCam;
        }
    }
#if UNITY_EDITOR
    [CustomEditor(typeof(UDONEventCalendar))]
    public class UDONCalendarEditor : Editor
    {
        float intensity = 0;
        bool fold = false;
        public override void OnInspectorGUI()
        {
            UDONEventCalendar _UDONCalendar = target as UDONEventCalendar;
            _UDONCalendar.Adjust();
            _UDONCalendar.SetMainCam();

            EditorGUILayout.Space();
            EditorGUILayout.LabelField("設定", EditorStyles.boldLabel);
            EditorGUI.indentLevel++;
            EditorGUI.BeginChangeCheck();
            intensity = EditorGUILayout.Slider("Intensity", intensity, -1.0f, 1.0f);
            if (EditorGUI.EndChangeCheck())
            {
                _UDONCalendar.intensity = intensity;
                _UDONCalendar.SetEmission();
            }
            EditorGUI.indentLevel--;
            EditorGUILayout.Space();
            //EditorGUILayout.LabelField("UDON Event Calendar", EditorStyles.boldLabel);
            EditorGUILayout.HelpBox("UDONイベントカレンダーのご利用ありがとうございます。\n更新情報や不具合報告、各種リクエスト等は以下のボタンよりお願いします。", MessageType.Info);
            using (new EditorGUILayout.HorizontalScope())
            {
                if (GUILayout.Button("Github"))
                {
                    Application.OpenURL("https://github.com/AoiKamishiro/VRChatUdon_ScrollEventCalendar");
                }
                if (GUILayout.Button("Discord Server"))
                {
                    Application.OpenURL("https://discord.gg/NG3DxyYkCf");
                }
            }
        }
    }
#endif
}
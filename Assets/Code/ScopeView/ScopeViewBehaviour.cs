using SunSharp.ObjectWrapper;
using UnityEngine;

namespace SunSharpUnity_VRDemo.ScopeView
{
    public class ScopeViewBehaviour : MonoBehaviour
    {
        private const string ArrayRangeMaxName = "_rangeMin";
        private const string ArrayRangeMinName = "_rangeMax";
        private const string ArrayName = "_floatArray";

        private static int _arrayRangeMaxId;
        private static int _arrayRangeMinId;
        private static int _arrayId;
        private static bool _shaderPropertiesFound;

        private const int bufferLength = 128;
        private short[] _buffer;
        private float[] _floatBuffer;

        public Material material;
        public ModuleHandle? _module { get; set; }

        private void Awake()
        {
            _buffer = new short[bufferLength];
            _floatBuffer = new float[bufferLength];

            if (!_shaderPropertiesFound)
            {
                _shaderPropertiesFound = true;

                _arrayRangeMaxId = Shader.PropertyToID(ArrayRangeMaxName);
                _arrayRangeMinId = Shader.PropertyToID(ArrayRangeMinName);
                _arrayId = Shader.PropertyToID(ArrayName);
            }
        }

        private void Start()
        {
        }

        private void Update()
        {
            if (_module == null)
                return;

            var count = _module.Value.ReadScope(default, _buffer);
            for (int i = 0; i < count; i++)
                _floatBuffer[i] = _buffer[i] / 32767f;

            material.SetFloatArray(_arrayId, _floatBuffer);
            material.SetInteger(_arrayRangeMaxId, count - 1);
            material.SetInteger(_arrayRangeMinId, 0);
        }
    }
}
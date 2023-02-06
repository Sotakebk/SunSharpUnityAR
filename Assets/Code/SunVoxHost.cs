using SunSharp.ObjectWrapper;
using SunSharp.Unity;
using UnityEngine;

namespace SunSharpUnity_VRDemo
{
    public class SunVoxHost : MonoBehaviour
    {
        public static SunVox SunVoxInstance { get; private set; }

        private void Awake()
        {
            var lib = Library.Instance;
            SunVoxInstance = new SunVox(lib);
        }
    }
}
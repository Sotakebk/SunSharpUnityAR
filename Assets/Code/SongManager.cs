using SunSharp.Unity;
using SunSharpUnity_VRDemo.ScopeView;
using UnityEngine;
namespace SunSharpUnity_VRDemo
{
    public class SongManager : MonoBehaviour
    {
        [SerializeField] private SongAsset song;

        public ScopeViewBehaviour OutputScopeView;

        private void Start()
        {
            var sv = SunVoxHost.SunVoxInstance;
            var slot = sv.Slots[0];

            slot.Open();
            slot.Load(song.Data);
            slot.PlayFromBeginning();
            slot.Synthesizer.TryGetModule(0, out var module);
            OutputScopeView._module = module;
        }
    }
}
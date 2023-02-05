using UnityEngine;
using SunSharp.Unity;
using SunSharp.ObjectWrapper;

namespace SunSharpUnity_VRDemo {

    public class Test : MonoBehaviour
    {
        [SerializeField] private SongAsset song;
        private SunVox _sv;

        private void Start()
        {
            var lib = Library.Instance;

            _sv = new SunVox(lib);
            Debug.Log(_sv.Version.ToString());
            var slot = _sv.Slots[0];
            slot.Open();
            Debug.Log("Loading song...");
            slot.Load(song.Data);
            Debug.Log($"Loaded song: {slot.GetSongName()}");
            slot.PlayFromBeginning();
        }
    }
}
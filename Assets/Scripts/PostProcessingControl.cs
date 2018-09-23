using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class PostProcessingControl : MonoBehaviour
{
    public GameObject TEXT;
    public float MinShakeIntensity;
    public float MaxShakeIntensity;
    public float ShakeIncreaseSpeed;
    public float MaxGrainSize;
    public float MaxGrainIntensity;
    public float GrianSpeed;
    public float MaxCAIntesity;
    public float CASpeed;
    private PostProcessVolume PPV;
    private PostProcessProfile PPP;
    private Bloom A;
    private Grain B;
    private ChromaticAberration C;

    void Start ()
    {
        TEXT.SetActive(false);
        PPV = GetComponent<PostProcessVolume>();
        PPP = PPV.profile;
        PPP.TryGetSettings<Bloom>(out A);
        PPP.TryGetSettings<Grain>(out B);
        PPP.TryGetSettings<ChromaticAberration>(out C);
    }
	void Update ()
    {
        if(B!=null)
        {
            if (Time.time > 2)
            {
                if (B.size < MaxGrainSize) { B.size.value += GrianSpeed * Time.deltaTime; }
                if (B.intensity < MaxGrainIntensity) { B.intensity.value += GrianSpeed * Time.deltaTime; }
            }
            if (Time.time > 15) if (C.intensity < MaxCAIntesity) { C.intensity.value += CASpeed * Time.deltaTime; }
        }
        if (Time.time>20)
        {
            if (TEXT != null) TEXT.SetActive(true);
            transform.Translate(Random.insideUnitSphere*MinShakeIntensity);
            if (MinShakeIntensity < MaxShakeIntensity) MinShakeIntensity += ShakeIncreaseSpeed * Time.deltaTime;
        }
    }
}

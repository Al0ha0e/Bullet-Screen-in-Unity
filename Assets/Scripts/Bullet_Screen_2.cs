using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class Bullet_Screen_2 : MonoBehaviour
{
    public int MaxBulletCnt;
    public float Width;
    public float MaxSpeed;
    public float MinSpeed;
    public float MaxSize;
    public float MinSize;
    public float ColorL;
    public float ColorR;
    public Material mat;
    public ComputeShader Master;
    private int BulletCnt;
    private List<BulletGenerator> Q;
    public static List<BulletGenerator> DrawList;

    public void Start()
    {
        BulletCnt = MaxBulletCnt;
        Q = new List<BulletGenerator>();
        DrawList = new List<BulletGenerator>();
        BulletGenerator ss = new BulletGenerator(2, MaxBulletCnt, Width, MinSpeed, MaxSpeed, MaxSize, MinSize, ColorL, ColorR, Master);
        ss.Active = true;
        Q.Add(ss);
        BulletGenerator sss = new BulletGenerator(2, MaxBulletCnt, Width, MinSpeed, MaxSpeed, MaxSize, MinSize, ColorL, ColorR, Master);
        sss.Active = true;
        Q.Add(sss);
    }
    public void Update()
    {
        foreach (BulletGenerator t in Q) t.Update(Time.deltaTime);
    }
    public void OnRenderObject()
    {
        foreach (BulletGenerator t in DrawList)
        {
            mat.SetBuffer("Position", t.Position);
            mat.SetBuffer("Color", t._Color);
            
            if (t.Type == 2) { mat.SetPass(1); }
            else { mat.SetPass(0); }
            Graphics.DrawProcedural(MeshTopology.Points, BulletCnt);
        }
        DrawList.Clear();
    }
    public void OnDestroy()
    {
        foreach (BulletGenerator t in Q) t.Dispose();
    }
}

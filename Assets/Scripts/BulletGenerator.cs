using System.Collections;
using System.Collections.Generic;
using System;
using UnityEngine;

public class BulletGenerator:IDisposable
{
    public bool Active;
    public int Type; // 0 horizontal 1 vertical
    private int MaxBulletCnt;
    private float Width;
    private float MinSpeed;
    private float MaxSpeed;
    private float MaxSize;
    private float MinSize;
    private ComputeShader Master;
    public ComputeBuffer Position;
    private ComputeBuffer Speed;
    public ComputeBuffer _Color;
    private int Vertical;
    private int Horizontal;
    private Vector4[] position;
    private float[] speed;
    private Vector3[] color;
    public BulletGenerator(int type,int maxbulletcnt,float width,float minspeed,float maxspeed,float maxsize,float minsize,float colorl,float colorr,ComputeShader master)
    {
        Active = false;
        Type = type;
        MaxBulletCnt = maxbulletcnt;
        Width = width;
        MinSpeed = minspeed;
        MaxSpeed = maxspeed;
        MaxSize = maxsize; MinSize = minsize;
        Master = master;
        Vertical = Master.FindKernel("Vertical");
        Horizontal = Master.FindKernel("Horizontal");
        Position = new ComputeBuffer(MaxBulletCnt, 16);
        Speed = new ComputeBuffer(MaxBulletCnt, 4);
        _Color = new ComputeBuffer(MaxBulletCnt, 12);
        position = new Vector4[MaxBulletCnt];
        speed = new float[MaxBulletCnt];
        color = new Vector3[MaxBulletCnt];
        int i;
        for (i = 0; i < MaxBulletCnt; i++)
        {
            if (Type == 0) { position[i] = new Vector4(-100.0f, UnityEngine.Random.Range(-Width, Width), UnityEngine.Random.Range(2.0f, -2.0f), UnityEngine.Random.Range(MinSize, MaxSize)); }
            else if(Type==1){ position[i] = new Vector4(UnityEngine.Random.Range(0.0f, Width), -50.0f, UnityEngine.Random.Range(2.0f, -2.0f), UnityEngine.Random.Range(MinSize, MaxSize)); }
            else { position[i] = new Vector4(UnityEngine.Random.Range(0.0f, 2*Mathf.PI), 0.0f, 40.0f, UnityEngine.Random.Range(MinSize, MaxSize)); }//x RAD z POS w Radius
            speed[i] = UnityEngine.Random.Range(MinSpeed, MaxSpeed);
            color[i] = new Vector3(UnityEngine.Random.Range(colorl, colorr), UnityEngine.Random.Range(colorl, colorr), UnityEngine.Random.Range(colorl, colorr));
            //color[i] = UnityEngine.Random.Range(1,213);
        }
        Position.SetData(position);
        Speed.SetData(speed);
        _Color.SetData(color);
    }
    public void Update(float deltatime)
    {
        if(Active)
        {
            Bullet_Screen_2.DrawList.Add(this);
            string prefix;
            if (Type == 0) { prefix = "Horizontal"; }
            else if(Type==1){ prefix = "Vertical"; }
            else { prefix = "Column"; }
            Master.SetFloat(prefix + "Deltatime", deltatime);
            Master.SetBuffer(Type, prefix + "Position", Position);
            Master.SetBuffer(Type, prefix + "Speed", Speed);
            Master.Dispatch(Type,MaxBulletCnt,1,1);
        }
    }
    public void Dispose()
    {
        Position.Release();
        Speed.Release();
        _Color.Release();
    }
}

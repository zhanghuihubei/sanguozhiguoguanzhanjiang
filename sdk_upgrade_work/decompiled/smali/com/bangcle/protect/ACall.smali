.class public Lcom/bangcle/protect/ACall;
.super Ljava/lang/Object;
.source "ACall.java"


# static fields
.field private static acall:Lcom/bangcle/protect/ACall;


# direct methods
.method static constructor <clinit>()V
    .locals 4

    .prologue
    .line 22
    invoke-static {}, Lcom/bangcle/protect/Util;->getCPUABI()Ljava/lang/String;

    move-result-object v0

    .line 24
    .local v0, "cpuinfo":Ljava/lang/String;
    const-string v2, "x86"

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    .line 26
    sget-object v2, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    invoke-static {v2}, Lcom/bangcle/protect/Util;->runAll1(Landroid/content/Context;)V

    .line 27
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/.cache/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "libsecexe.x86.so"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 28
    .local v1, "f":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 29
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/.cache/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "libsecexe.x86.so"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/System;->load(Ljava/lang/String;)V

    .line 38
    .end local v1    # "f":Ljava/io/File;
    :goto_0
    const/4 v2, 0x0

    sput-object v2, Lcom/bangcle/protect/ACall;->acall:Lcom/bangcle/protect/ACall;

    return-void

    .line 31
    .restart local v1    # "f":Ljava/io/File;
    :cond_0
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/lib/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "libsecexe.x86.so"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/System;->load(Ljava/lang/String;)V

    goto :goto_0

    .line 34
    .end local v1    # "f":Ljava/io/File;
    :cond_1
    sget-object v2, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    invoke-static {v2}, Lcom/bangcle/protect/Util;->runAll1(Landroid/content/Context;)V

    .line 35
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v3, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    invoke-virtual {v3}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/.cache/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "libsecexe.so"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/System;->load(Ljava/lang/String;)V

    goto :goto_0
.end method

.method private constructor <init>()V
    .locals 0

    .prologue
    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 42
    return-void
.end method

.method public static getACall()Lcom/bangcle/protect/ACall;
    .locals 1

    .prologue
    .line 44
    sget-object v0, Lcom/bangcle/protect/ACall;->acall:Lcom/bangcle/protect/ACall;

    if-nez v0, :cond_0

    .line 45
    new-instance v0, Lcom/bangcle/protect/ACall;

    invoke-direct {v0}, Lcom/bangcle/protect/ACall;-><init>()V

    sput-object v0, Lcom/bangcle/protect/ACall;->acall:Lcom/bangcle/protect/ACall;

    .line 47
    :cond_0
    sget-object v0, Lcom/bangcle/protect/ACall;->acall:Lcom/bangcle/protect/ACall;

    return-object v0
.end method


# virtual methods
.method public native a1([B[B)V
.end method

.method public native at1(Landroid/app/Application;Landroid/content/Context;)V
.end method

.method public native at2(Landroid/app/Application;Landroid/content/Context;)V
.end method

.method public native c1(Ljava/lang/Object;Ljava/lang/Object;)V
.end method

.method public native c2(Ljava/lang/Object;Ljava/lang/Object;)V
.end method

.method public native c3(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
.end method

.method public native r1([B[B)V
.end method

.method public native r2([B[B[B)V
.end method

.method public native rc1(Landroid/content/Context;)Ljava/lang/ClassLoader;
.end method

.method public native s1(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;)V
.end method

.method public native set1(Landroid/app/Activity;Ljava/lang/ClassLoader;)Ljava/lang/Object;
.end method

.method public native set2(Landroid/app/Application;Landroid/app/Application;Ljava/lang/ClassLoader;Landroid/content/Context;)Ljava/lang/Object;
.end method

.method public native set3(Landroid/app/Application;)V
.end method

.method public native set3(Ljava/lang/Object;Ljava/lang/Object;)V
.end method

.method public native set4()V
.end method

.method public native set5(Landroid/content/ContentProvider;)V
.end method

.method public native set8()V
.end method

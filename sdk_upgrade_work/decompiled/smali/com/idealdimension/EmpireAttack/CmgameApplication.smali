.class public Lcom/idealdimension/EmpireAttack/CmgameApplication;
.super Landroid/app/Application;
.source "ApplicationTemplate.java"


# static fields
.field public static FirstApplication:Ljava/lang/String;

.field public static realApplication:Landroid/app/Application;


# instance fields
.field private cl:Ldalvik/system/DexClassLoader;


# direct methods
.method static constructor <clinit>()V
    .locals 1

    .prologue
    .line 13
    const/4 v0, 0x0

    sput-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    .line 14
    const-string v0, "com.idealdimension.EmpireAttack.CmgameApplication"

    sput-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->FirstApplication:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 11
    invoke-direct {p0}, Landroid/app/Application;-><init>()V

    return-void
.end method

.method private getField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    .locals 5
    .param p2, "name"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class",
            "<*>;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/reflect/Field;"
        }
    .end annotation

    .prologue
    .line 17
    .local p1, "cls":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    invoke-virtual {p1}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v2

    array-length v3, v2

    const/4 v1, 0x0

    :goto_0
    if-lt v1, v3, :cond_1

    .line 26
    const/4 v0, 0x0

    :cond_0
    return-object v0

    .line 17
    :cond_1
    aget-object v0, v2, v1

    .line 19
    .local v0, "field":Ljava/lang/reflect/Field;
    invoke-virtual {v0}, Ljava/lang/reflect/Field;->isAccessible()Z

    move-result v4

    if-nez v4, :cond_2

    .line 20
    const/4 v4, 0x1

    invoke-virtual {v0, v4}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 22
    :cond_2
    invoke-virtual {v0}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, p2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_0

    .line 17
    add-int/lit8 v1, v1, 0x1

    goto :goto_0
.end method


# virtual methods
.method public onConfigurationChanged(Landroid/content/res/Configuration;)V
    .locals 1
    .param p1, "newConfig"    # Landroid/content/res/Configuration;

    .prologue
    .line 103
    invoke-super {p0, p1}, Landroid/app/Application;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 105
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    if-eqz v0, :cond_0

    .line 106
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {v0, p1}, Landroid/app/Application;->onConfigurationChanged(Landroid/content/res/Configuration;)V

    .line 109
    :cond_0
    return-void
.end method

.method public onCreate()V
    .locals 7

    .prologue
    .line 47
    invoke-super {p0}, Landroid/app/Application;->onCreate()V

    .line 49
    invoke-static {}, Lcom/bangcle/protect/Util;->getCustomClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    if-nez v4, :cond_0

    .line 50
    invoke-static {p0}, Lcom/bangcle/protect/Util;->runAll(Landroid/content/Context;)V

    .line 53
    :cond_0
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->FirstApplication:Ljava/lang/String;

    .line 56
    .local v0, "applicationClass":Ljava/lang/String;
    :try_start_0
    invoke-static {}, Lcom/bangcle/protect/Util;->getCustomClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    check-cast v4, Ldalvik/system/DexClassLoader;

    iput-object v4, p0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->cl:Ldalvik/system/DexClassLoader;

    .line 57
    iget-object v4, p0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->cl:Ldalvik/system/DexClassLoader;

    invoke-virtual {v4, v0}, Ldalvik/system/DexClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    .line 58
    .local v1, "c":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    invoke-virtual {v1}, Ljava/lang/Class;->newInstance()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/app/Application;

    sput-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 65
    .end local v1    # "c":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    :goto_0
    sget-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    if-eqz v4, :cond_2

    .line 67
    invoke-static {}, Lcom/bangcle/protect/ACall;->getACall()Lcom/bangcle/protect/ACall;

    move-result-object v3

    .line 68
    .local v3, "p":Lcom/bangcle/protect/ACall;
    sget-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {p0}, Lcom/idealdimension/EmpireAttack/CmgameApplication;->getBaseContext()Landroid/content/Context;

    move-result-object v5

    invoke-virtual {v3, v4, v5}, Lcom/bangcle/protect/ACall;->at1(Landroid/app/Application;Landroid/content/Context;)V

    .line 70
    sget-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    iget-object v5, p0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->cl:Ldalvik/system/DexClassLoader;

    invoke-virtual {p0}, Lcom/idealdimension/EmpireAttack/CmgameApplication;->getBaseContext()Landroid/content/Context;

    move-result-object v6

    invoke-virtual {v3, p0, v4, v5, v6}, Lcom/bangcle/protect/ACall;->set2(Landroid/app/Application;Landroid/app/Application;Ljava/lang/ClassLoader;Landroid/content/Context;)Ljava/lang/Object;

    .line 73
    :try_start_1
    sget-object v4, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    const/4 v5, 0x0

    const/4 v6, 0x3

    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Ljava/lang/Float;->parseFloat(Ljava/lang/String;)F

    move-result v4

    const v5, 0x40066666    # 2.1f

    cmpg-float v4, v4, v5

    if-gtz v4, :cond_1

    .line 74
    sget-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {v3, v4}, Lcom/bangcle/protect/ACall;->set3(Landroid/app/Application;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_2

    .line 80
    :cond_1
    :goto_1
    invoke-static {}, Lcom/bangcle/protect/Util;->doProvider()V

    .line 82
    sget-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {v4}, Landroid/app/Application;->onCreate()V

    .line 85
    :try_start_2
    invoke-virtual {v3}, Lcom/bangcle/protect/ACall;->set8()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    .line 91
    .end local v3    # "p":Lcom/bangcle/protect/ACall;
    :cond_2
    :goto_2
    return-void

    .line 60
    :catch_0
    move-exception v2

    .line 62
    .local v2, "e":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    .line 63
    const/4 v4, 0x0

    sput-object v4, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    goto :goto_0

    .line 86
    .end local v2    # "e":Ljava/lang/Exception;
    .restart local v3    # "p":Lcom/bangcle/protect/ACall;
    :catch_1
    move-exception v4

    goto :goto_2

    .line 76
    :catch_2
    move-exception v4

    goto :goto_1
.end method

.method public onLowMemory()V
    .locals 1

    .prologue
    .line 112
    invoke-super {p0}, Landroid/app/Application;->onLowMemory()V

    .line 113
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    if-eqz v0, :cond_0

    .line 114
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {v0}, Landroid/app/Application;->onLowMemory()V

    .line 116
    :cond_0
    return-void
.end method

.method public onTerminate()V
    .locals 1

    .prologue
    .line 95
    invoke-super {p0}, Landroid/app/Application;->onTerminate()V

    .line 97
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    if-eqz v0, :cond_0

    .line 98
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {v0}, Landroid/app/Application;->onTerminate()V

    .line 100
    :cond_0
    return-void
.end method

.method public onTrimMemory(I)V
    .locals 1
    .param p1, "level"    # I

    .prologue
    .line 119
    :try_start_0
    invoke-super {p0, p1}, Landroid/app/Application;->onTrimMemory(I)V

    .line 120
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    if-eqz v0, :cond_0

    .line 121
    sget-object v0, Lcom/idealdimension/EmpireAttack/CmgameApplication;->realApplication:Landroid/app/Application;

    invoke-virtual {v0, p1}, Landroid/app/Application;->onTrimMemory(I)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 126
    :cond_0
    :goto_0
    return-void

    .line 123
    :catch_0
    move-exception v0

    goto :goto_0
.end method

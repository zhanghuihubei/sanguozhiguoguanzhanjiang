.class public Lcom/bangcle/protect/Util;
.super Ljava/lang/Object;
.source "Util.java"


# static fields
.field private static BUILD_TIME:Ljava/lang/String;

.field public static CPUABI:Ljava/lang/String;

.field private static VERSION_NAME:Ljava/lang/String;

.field private static cl:Ljava/lang/ClassLoader;

.field static hexDigits:[B

.field public static isX86:Z

.field private static ps:Ljava/util/ArrayList;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/ArrayList",
            "<",
            "Landroid/content/ContentProvider;",
            ">;"
        }
    .end annotation
.end field

.field public static x86Ctx:Landroid/content/Context;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .prologue
    const/4 v1, 0x0

    .line 41
    sput-object v1, Lcom/bangcle/protect/Util;->cl:Ljava/lang/ClassLoader;

    .line 42
    const-string v0, "1.0.0"

    sput-object v0, Lcom/bangcle/protect/Util;->VERSION_NAME:Ljava/lang/String;

    .line 43
    const-string v0, "2015-01-0816:25:33"

    sput-object v0, Lcom/bangcle/protect/Util;->BUILD_TIME:Ljava/lang/String;

    .line 45
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sput-object v0, Lcom/bangcle/protect/Util;->ps:Ljava/util/ArrayList;

    .line 46
    sput-object v1, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    .line 496
    const/4 v0, 0x0

    sput-boolean v0, Lcom/bangcle/protect/Util;->isX86:Z

    .line 733
    const/16 v0, 0x10

    new-array v0, v0, [B

    fill-array-data v0, :array_0

    sput-object v0, Lcom/bangcle/protect/Util;->hexDigits:[B

    .line 844
    sput-object v1, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;

    return-void

    .line 733
    nop

    :array_0
    .array-data 1
        0x30t
        0x31t
        0x32t
        0x33t
        0x34t
        0x35t
        0x36t
        0x37t
        0x38t
        0x39t
        0x41t
        0x42t
        0x43t
        0x44t
        0x45t
        0x46t
    .end array-data
.end method

.method public constructor <init>()V
    .locals 0

    .prologue
    .line 40
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static CopyArmLib(Landroid/content/Context;)V
    .locals 11
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 463
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v9

    iget-object v0, v9, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 464
    .local v0, "apkFilePath":Ljava/lang/String;
    const/4 v6, 0x0

    .line 466
    .local v6, "jarFile":Ljava/util/jar/JarFile;
    :try_start_0
    new-instance v7, Ljava/util/jar/JarFile;

    invoke-direct {v7, v0}, Ljava/util/jar/JarFile;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 467
    .end local v6    # "jarFile":Ljava/util/jar/JarFile;
    .local v7, "jarFile":Ljava/util/jar/JarFile;
    const/4 v4, 0x0

    .line 468
    .local v4, "jarEntry":Ljava/util/jar/JarEntry;
    :try_start_1
    invoke-virtual {v7}, Ljava/util/jar/JarFile;->entries()Ljava/util/Enumeration;

    move-result-object v3

    .line 469
    .local v3, "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v9

    if-nez v9, :cond_1

    move-object v6, v7

    .line 494
    .end local v3    # "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    .end local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    .end local v7    # "jarFile":Ljava/util/jar/JarFile;
    .restart local v6    # "jarFile":Ljava/util/jar/JarFile;
    :goto_1
    return-void

    .line 470
    .end local v6    # "jarFile":Ljava/util/jar/JarFile;
    .restart local v3    # "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    .restart local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    .restart local v7    # "jarFile":Ljava/util/jar/JarFile;
    :cond_1
    invoke-interface {v3}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v4

    .end local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    check-cast v4, Ljava/util/jar/JarEntry;

    .line 471
    .restart local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    invoke-virtual {v4}, Ljava/util/jar/JarEntry;->getName()Ljava/lang/String;

    move-result-object v5

    .line 472
    .local v5, "jarEntryName":Ljava/lang/String;
    const-string v9, "assets/libsecexe.so"

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    .line 473
    const-string v9, "assets/"

    .line 474
    const-string v10, ""

    .line 473
    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 475
    .local v8, "soName":Ljava/lang/String;
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 476
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 475
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 477
    .local v1, "destSoName":Ljava/lang/String;
    invoke-static {v1, v7, v4}, Lcom/bangcle/protect/Util;->realCopy(Ljava/lang/String;Ljava/util/jar/JarFile;Ljava/util/zip/ZipEntry;)V

    .line 480
    .end local v1    # "destSoName":Ljava/lang/String;
    .end local v8    # "soName":Ljava/lang/String;
    :cond_2
    const-string v9, "assets/libsecmain.so"

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_0

    .line 481
    const-string v9, "assets/"

    .line 482
    const-string v10, ""

    .line 481
    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 483
    .restart local v8    # "soName":Ljava/lang/String;
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 484
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "libsecmain.so"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 483
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 485
    .restart local v1    # "destSoName":Ljava/lang/String;
    invoke-static {v1, v7, v4}, Lcom/bangcle/protect/Util;->realCopy(Ljava/lang/String;Ljava/util/jar/JarFile;Ljava/util/zip/ZipEntry;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    .line 489
    .end local v1    # "destSoName":Ljava/lang/String;
    .end local v3    # "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    .end local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    .end local v5    # "jarEntryName":Ljava/lang/String;
    .end local v8    # "soName":Ljava/lang/String;
    :catch_0
    move-exception v2

    move-object v6, v7

    .line 491
    .end local v7    # "jarFile":Ljava/util/jar/JarFile;
    .local v2, "e":Ljava/io/IOException;
    .restart local v6    # "jarFile":Ljava/util/jar/JarFile;
    :goto_2
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_1

    .line 489
    .end local v2    # "e":Ljava/io/IOException;
    :catch_1
    move-exception v2

    goto :goto_2
.end method

.method private static CopyBinaryFile(Landroid/content/Context;)V
    .locals 9
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 592
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "/data/data/"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    .line 593
    const-string v7, "/.cache/classes.jar"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    .line 592
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 594
    .local v3, "jarFileName":Ljava/lang/String;
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "/data/data/"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "/.cache/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    .line 595
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    .line 594
    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 596
    .local v4, "myDexOptFile":Ljava/lang/String;
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "/data/data/"

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "/.cache/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, ".art"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 599
    .local v0, "dex2oat":Ljava/lang/String;
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 600
    .local v2, "jarFile":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v6

    if-nez v6, :cond_0

    .line 601
    invoke-static {}, Lcom/bangcle/protect/ACall;->getACall()Lcom/bangcle/protect/ACall;

    move-result-object v6

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->getBytes()[B

    move-result-object v7

    .line 602
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v8

    iget-object v8, v8, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    invoke-virtual {v8}, Ljava/lang/String;->getBytes()[B

    move-result-object v8

    .line 601
    invoke-virtual {v6, v7, v8}, Lcom/bangcle/protect/ACall;->a1([B[B)V

    .line 610
    :cond_0
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v6

    .line 611
    new-instance v7, Ljava/lang/StringBuilder;

    const-string v8, "chmod 755 "

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 610
    invoke-virtual {v6, v7}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v5

    .line 612
    .local v5, "proc":Ljava/lang/Process;
    invoke-virtual {v5}, Ljava/lang/Process;->waitFor()I

    .line 613
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v6

    .line 614
    new-instance v7, Ljava/lang/StringBuilder;

    const-string v8, "chmod 755 "

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 613
    invoke-virtual {v6, v7}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v5

    .line 615
    invoke-virtual {v5}, Ljava/lang/Process;->waitFor()I
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1

    .line 626
    .end local v5    # "proc":Ljava/lang/Process;
    :goto_0
    return-void

    .line 616
    :catch_0
    move-exception v1

    .line 618
    .local v1, "e":Ljava/io/IOException;
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0

    .line 619
    .end local v1    # "e":Ljava/io/IOException;
    :catch_1
    move-exception v1

    .line 621
    .local v1, "e":Ljava/lang/InterruptedException;
    invoke-virtual {v1}, Ljava/lang/InterruptedException;->printStackTrace()V

    goto :goto_0
.end method

.method private static CopyLib(Landroid/content/Context;)V
    .locals 11
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 418
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v9

    iget-object v0, v9, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 419
    .local v0, "apkFilePath":Ljava/lang/String;
    const/4 v6, 0x0

    .line 421
    .local v6, "jarFile":Ljava/util/jar/JarFile;
    :try_start_0
    new-instance v7, Ljava/util/jar/JarFile;

    invoke-direct {v7, v0}, Ljava/util/jar/JarFile;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_1

    .line 422
    .end local v6    # "jarFile":Ljava/util/jar/JarFile;
    .local v7, "jarFile":Ljava/util/jar/JarFile;
    const/4 v4, 0x0

    .line 423
    .local v4, "jarEntry":Ljava/util/jar/JarEntry;
    :try_start_1
    invoke-virtual {v7}, Ljava/util/jar/JarFile;->entries()Ljava/util/Enumeration;

    move-result-object v3

    .line 424
    .local v3, "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    :cond_0
    :goto_0
    invoke-interface {v3}, Ljava/util/Enumeration;->hasMoreElements()Z

    move-result v9

    if-nez v9, :cond_1

    move-object v6, v7

    .line 460
    .end local v3    # "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    .end local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    .end local v7    # "jarFile":Ljava/util/jar/JarFile;
    .restart local v6    # "jarFile":Ljava/util/jar/JarFile;
    :goto_1
    return-void

    .line 425
    .end local v6    # "jarFile":Ljava/util/jar/JarFile;
    .restart local v3    # "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    .restart local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    .restart local v7    # "jarFile":Ljava/util/jar/JarFile;
    :cond_1
    invoke-interface {v3}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;

    move-result-object v4

    .end local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    check-cast v4, Ljava/util/jar/JarEntry;

    .line 426
    .restart local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    invoke-virtual {v4}, Ljava/util/jar/JarEntry;->getName()Ljava/lang/String;

    move-result-object v5

    .line 427
    .local v5, "jarEntryName":Ljava/lang/String;
    const-string v9, "assets/libsecexe.x86.so"

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_2

    .line 428
    const-string v9, "assets/"

    .line 429
    const-string v10, ""

    .line 428
    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 430
    .local v8, "soName":Ljava/lang/String;
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 431
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 430
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 432
    .local v1, "destSoName":Ljava/lang/String;
    invoke-static {v1, v7, v4}, Lcom/bangcle/protect/Util;->realCopy(Ljava/lang/String;Ljava/util/jar/JarFile;Ljava/util/zip/ZipEntry;)V

    .line 435
    .end local v1    # "destSoName":Ljava/lang/String;
    .end local v8    # "soName":Ljava/lang/String;
    :cond_2
    const-string v9, "assets/libsecmain.x86.so"

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_3

    .line 436
    const-string v9, "assets/"

    .line 437
    const-string v10, ""

    .line 436
    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 438
    .restart local v8    # "soName":Ljava/lang/String;
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 439
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "libsecmain.x86.so"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 438
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 440
    .restart local v1    # "destSoName":Ljava/lang/String;
    invoke-static {v1, v7, v4}, Lcom/bangcle/protect/Util;->realCopy(Ljava/lang/String;Ljava/util/jar/JarFile;Ljava/util/zip/ZipEntry;)V

    .line 443
    .end local v1    # "destSoName":Ljava/lang/String;
    .end local v8    # "soName":Ljava/lang/String;
    :cond_3
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "assets/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, ".x86"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_0

    .line 444
    const-string v9, "assets/"

    .line 445
    const-string v10, ""

    .line 444
    invoke-virtual {v5, v9, v10}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 446
    .restart local v8    # "soName":Ljava/lang/String;
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 447
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 446
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 448
    .restart local v1    # "destSoName":Ljava/lang/String;
    invoke-static {v1, v7, v4}, Lcom/bangcle/protect/Util;->realCopy(Ljava/lang/String;Ljava/util/jar/JarFile;Ljava/util/zip/ZipEntry;)V
    :try_end_1
    .catch Ljava/io/IOException; {:try_start_1 .. :try_end_1} :catch_0

    goto/16 :goto_0

    .line 455
    .end local v1    # "destSoName":Ljava/lang/String;
    .end local v3    # "iter":Ljava/util/Enumeration;, "Ljava/util/Enumeration<Ljava/util/jar/JarEntry;>;"
    .end local v4    # "jarEntry":Ljava/util/jar/JarEntry;
    .end local v5    # "jarEntryName":Ljava/lang/String;
    .end local v8    # "soName":Ljava/lang/String;
    :catch_0
    move-exception v2

    move-object v6, v7

    .line 457
    .end local v7    # "jarFile":Ljava/util/jar/JarFile;
    .local v2, "e":Ljava/io/IOException;
    .restart local v6    # "jarFile":Ljava/util/jar/JarFile;
    :goto_2
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto/16 :goto_1

    .line 455
    .end local v2    # "e":Ljava/io/IOException;
    :catch_1
    move-exception v2

    goto :goto_2
.end method

.method public static addProvider(Landroid/content/ContentProvider;)V
    .locals 2
    .param p0, "p"    # Landroid/content/ContentProvider;

    .prologue
    .line 49
    sget-object v1, Lcom/bangcle/protect/Util;->ps:Ljava/util/ArrayList;

    monitor-enter v1

    .line 51
    :try_start_0
    invoke-virtual {p0}, Landroid/content/ContentProvider;->getContext()Landroid/content/Context;

    move-result-object v0

    sput-object v0, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    .line 52
    invoke-static {}, Lcom/bangcle/protect/ACall;->getACall()Lcom/bangcle/protect/ACall;

    move-result-object v0

    invoke-virtual {v0, p0}, Lcom/bangcle/protect/ACall;->set5(Landroid/content/ContentProvider;)V

    .line 49
    monitor-exit v1

    .line 54
    return-void

    .line 49
    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method public static calFileMD5(Ljava/lang/String;)[B
    .locals 6
    .param p0, "path"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 756
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/lang/String;)V

    .line 757
    .local v1, "input":Ljava/io/FileInputStream;
    new-instance v3, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v3}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 758
    .local v3, "out":Ljava/io/ByteArrayOutputStream;
    const v5, 0x8000

    new-array v0, v5, [B

    .line 759
    .local v0, "buffer":[B
    const/4 v4, 0x0

    .line 760
    .local v4, "readed":I
    :goto_0
    invoke-virtual {v1, v0}, Ljava/io/FileInputStream;->read([B)I

    move-result v4

    if-gtz v4, :cond_0

    .line 763
    const-string v5, "MD5"

    invoke-static {v5}, Ljava/security/MessageDigest;->getInstance(Ljava/lang/String;)Ljava/security/MessageDigest;

    move-result-object v2

    .line 764
    .local v2, "md":Ljava/security/MessageDigest;
    invoke-virtual {v3}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/security/MessageDigest;->update([B)V

    .line 765
    invoke-virtual {v2}, Ljava/security/MessageDigest;->digest()[B

    move-result-object v5

    return-object v5

    .line 761
    .end local v2    # "md":Ljava/security/MessageDigest;
    :cond_0
    const/4 v5, 0x0

    invoke-virtual {v3, v0, v5, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0
.end method

.method private static checkSpace(Landroid/content/Context;)V
    .locals 9
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 570
    invoke-static {p0}, Lcom/bangcle/protect/Util;->isSpaceEnough(Landroid/content/Context;)Z

    move-result v6

    if-nez v6, :cond_0

    .line 573
    invoke-static {}, Lcom/bangcle/protect/Util;->getDataSize()J

    move-result-wide v4

    .line 574
    .local v4, "size":J
    invoke-static {p0}, Lcom/bangcle/protect/Util;->getClassesJarSize(Landroid/content/Context;)J

    move-result-wide v0

    .line 575
    .local v0, "classSize":J
    const-string v6, "SecApk"

    new-instance v7, Ljava/lang/StringBuilder;

    const-string v8, "Insufficient Space For SecApk available size:"

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 576
    invoke-virtual {v7, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v7

    const-string v8, " classSize"

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7, v0, v1}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    .line 575
    invoke-static {v6, v7}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 578
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v3

    .line 579
    .local v3, "r":Ljava/lang/Runtime;
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "kill -9 "

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v3, v6}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 586
    .end local v0    # "classSize":J
    .end local v3    # "r":Ljava/lang/Runtime;
    .end local v4    # "size":J
    :cond_0
    :goto_0
    return-void

    .line 581
    .restart local v0    # "classSize":J
    .restart local v4    # "size":J
    :catch_0
    move-exception v2

    .line 582
    .local v2, "ex":Ljava/lang/Exception;
    invoke-virtual {v2}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method private static checkUpdate(Landroid/content/Context;)V
    .locals 12
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 316
    :try_start_0
    new-instance v1, Ljava/io/File;

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-direct {v1, v9}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 318
    .local v1, "f":Ljava/io/File;
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v9

    .line 319
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    const/4 v11, 0x0

    .line 318
    invoke-virtual {v9, v10, v11}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v5

    .line 320
    .local v5, "pinfo":Landroid/content/pm/PackageInfo;
    iget v7, v5, Landroid/content/pm/PackageInfo;->versionCode:I

    .line 321
    .local v7, "versionCode":I
    iget-object v8, v5, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    .line 323
    .local v8, "versionName":Ljava/lang/String;
    if-nez v8, :cond_0

    .line 324
    sget-object v8, Lcom/bangcle/protect/Util;->VERSION_NAME:Ljava/lang/String;

    .line 328
    :cond_0
    new-instance v2, Ljava/io/File;

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 329
    const-string v10, "/.sec_version"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    .line 328
    invoke-direct {v2, v9}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 331
    .local v2, "fversion":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v9

    if-nez v9, :cond_2

    .line 332
    invoke-static {v1}, Lcom/bangcle/protect/Util;->deleteDirectory(Ljava/io/File;)Z

    .line 333
    invoke-static {v2, v7, v8}, Lcom/bangcle/protect/Util;->writeVersion(Ljava/io/File;ILjava/lang/String;)V

    .line 369
    .end local v5    # "pinfo":Landroid/content/pm/PackageInfo;
    .end local v7    # "versionCode":I
    .end local v8    # "versionName":Ljava/lang/String;
    :cond_1
    :goto_0
    return-void

    .line 335
    .restart local v5    # "pinfo":Landroid/content/pm/PackageInfo;
    .restart local v7    # "versionCode":I
    .restart local v8    # "versionName":Ljava/lang/String;
    :cond_2
    invoke-static {v2}, Lcom/bangcle/protect/Util;->readVersions(Ljava/io/File;)[Ljava/lang/String;

    move-result-object v6

    .line 336
    .local v6, "ret":[Ljava/lang/String;
    if-nez v6, :cond_3

    .line 337
    invoke-static {v1}, Lcom/bangcle/protect/Util;->deleteDirectory(Ljava/io/File;)Z

    .line 338
    invoke-virtual {v2}, Ljava/io/File;->delete()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 356
    .end local v1    # "f":Ljava/io/File;
    .end local v2    # "fversion":Ljava/io/File;
    .end local v5    # "pinfo":Landroid/content/pm/PackageInfo;
    .end local v6    # "ret":[Ljava/lang/String;
    .end local v7    # "versionCode":I
    .end local v8    # "versionName":Ljava/lang/String;
    :catch_0
    move-exception v0

    .line 358
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 360
    new-instance v1, Ljava/io/File;

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    const-string v10, "/.cache/"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-direct {v1, v9}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 361
    .restart local v1    # "f":Ljava/io/File;
    invoke-static {v1}, Lcom/bangcle/protect/Util;->deleteDirectory(Ljava/io/File;)Z

    .line 362
    new-instance v2, Ljava/io/File;

    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 363
    const-string v10, "/.sec_version"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    .line 362
    invoke-direct {v2, v9}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 364
    .restart local v2    # "fversion":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v9

    if-eqz v9, :cond_1

    .line 365
    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    goto :goto_0

    .line 342
    .end local v0    # "e":Ljava/lang/Exception;
    .restart local v5    # "pinfo":Landroid/content/pm/PackageInfo;
    .restart local v6    # "ret":[Ljava/lang/String;
    .restart local v7    # "versionCode":I
    .restart local v8    # "versionName":Ljava/lang/String;
    :cond_3
    const/4 v9, 0x0

    :try_start_1
    aget-object v9, v6, v9

    invoke-static {v9}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v3

    .line 343
    .local v3, "localVersionCode":I
    const/4 v9, 0x1

    aget-object v4, v6, v9

    .line 344
    .local v4, "localVersionName":Ljava/lang/String;
    invoke-virtual {v4, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_4

    .line 345
    if-eq v3, v7, :cond_1

    .line 350
    :cond_4
    invoke-static {v1}, Lcom/bangcle/protect/Util;->deleteDirectory(Ljava/io/File;)Z

    .line 351
    invoke-virtual {v2}, Ljava/io/File;->delete()Z
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0
.end method

.method private static checkX86(Landroid/content/Context;)V
    .locals 7
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 499
    invoke-static {}, Lcom/bangcle/protect/Util;->getCPUABI()Ljava/lang/String;

    move-result-object v2

    .line 500
    .local v2, "cpuinfo":Ljava/lang/String;
    const-string v5, "x86"

    invoke-virtual {v2, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 501
    const/4 v5, 0x1

    sput-boolean v5, Lcom/bangcle/protect/Util;->isX86:Z

    .line 503
    :cond_0
    sget-boolean v5, Lcom/bangcle/protect/Util;->isX86:Z

    if-eqz v5, :cond_2

    .line 504
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "/data/data/"

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 505
    const-string v6, "/.cache/"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    .line 504
    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 506
    .local v4, "libfileName":Ljava/lang/String;
    new-instance v3, Ljava/io/File;

    invoke-direct {v3, v4}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 507
    .local v3, "libFile":Ljava/io/File;
    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v5

    if-nez v5, :cond_1

    .line 508
    invoke-static {p0}, Lcom/bangcle/protect/Util;->CopyLib(Landroid/content/Context;)V

    .line 521
    .end local v3    # "libFile":Ljava/io/File;
    .end local v4    # "libfileName":Ljava/lang/String;
    :cond_1
    :goto_0
    return-void

    .line 511
    :cond_2
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "/data/data/"

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "/.cache/"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "libsecexe.so"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 512
    .local v1, "armLibFilename":Ljava/lang/String;
    new-instance v0, Ljava/io/File;

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 513
    .local v0, "armLibFile":Ljava/io/File;
    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v5

    if-nez v5, :cond_1

    .line 514
    invoke-static {p0}, Lcom/bangcle/protect/Util;->CopyArmLib(Landroid/content/Context;)V

    goto :goto_0
.end method

.method private static copyJarFile(Landroid/content/Context;)V
    .locals 12
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 234
    new-instance v10, Ljava/lang/StringBuilder;

    const-string v11, "/data/data/"

    invoke-direct {v10, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    .line 235
    const-string v11, "/.cache/classes.jar"

    invoke-virtual {v10, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v10

    .line 234
    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    .line 238
    .local v6, "jarFileName":Ljava/lang/String;
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v10

    iget-object v0, v10, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 239
    .local v0, "apkFilePath":Ljava/lang/String;
    new-instance v5, Ljava/util/jar/JarFile;

    invoke-direct {v5, v0}, Ljava/util/jar/JarFile;-><init>(Ljava/lang/String;)V

    .line 240
    .local v5, "jar":Ljava/util/jar/JarFile;
    const-string v10, "assets/bangcle_classes.jar"

    invoke-virtual {v5, v10}, Ljava/util/jar/JarFile;->getEntry(Ljava/lang/String;)Ljava/util/zip/ZipEntry;

    move-result-object v2

    .line 242
    .local v2, "entry":Ljava/util/zip/ZipEntry;
    new-instance v9, Ljava/io/File;

    invoke-direct {v9, v6}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 244
    .local v9, "outfile":Ljava/io/File;
    const/high16 v10, 0x10000

    new-array v1, v10, [B

    .line 245
    .local v1, "buffer":[B
    new-instance v4, Ljava/io/BufferedInputStream;

    invoke-virtual {v5, v2}, Ljava/util/jar/JarFile;->getInputStream(Ljava/util/zip/ZipEntry;)Ljava/io/InputStream;

    move-result-object v10

    invoke-direct {v4, v10}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 246
    .local v4, "in":Ljava/io/InputStream;
    new-instance v8, Ljava/io/BufferedOutputStream;

    new-instance v10, Ljava/io/FileOutputStream;

    .line 247
    invoke-direct {v10, v9}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 246
    invoke-direct {v8, v10}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 250
    .local v8, "out":Ljava/io/OutputStream;
    :goto_0
    invoke-virtual {v4, v1}, Ljava/io/InputStream;->read([B)I

    move-result v7

    .line 251
    .local v7, "nBytes":I
    if-gtz v7, :cond_0

    .line 255
    invoke-virtual {v8}, Ljava/io/OutputStream;->flush()V

    .line 256
    invoke-virtual {v8}, Ljava/io/OutputStream;->close()V

    .line 257
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 261
    .end local v0    # "apkFilePath":Ljava/lang/String;
    .end local v1    # "buffer":[B
    .end local v2    # "entry":Ljava/util/zip/ZipEntry;
    .end local v4    # "in":Ljava/io/InputStream;
    .end local v5    # "jar":Ljava/util/jar/JarFile;
    .end local v7    # "nBytes":I
    .end local v8    # "out":Ljava/io/OutputStream;
    .end local v9    # "outfile":Ljava/io/File;
    :goto_1
    return-void

    .line 253
    .restart local v0    # "apkFilePath":Ljava/lang/String;
    .restart local v1    # "buffer":[B
    .restart local v2    # "entry":Ljava/util/zip/ZipEntry;
    .restart local v4    # "in":Ljava/io/InputStream;
    .restart local v5    # "jar":Ljava/util/jar/JarFile;
    .restart local v7    # "nBytes":I
    .restart local v8    # "out":Ljava/io/OutputStream;
    .restart local v9    # "outfile":Ljava/io/File;
    :cond_0
    const/4 v10, 0x0

    invoke-virtual {v8, v1, v10, v7}, Ljava/io/OutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 258
    .end local v0    # "apkFilePath":Ljava/lang/String;
    .end local v1    # "buffer":[B
    .end local v2    # "entry":Ljava/util/zip/ZipEntry;
    .end local v4    # "in":Ljava/io/InputStream;
    .end local v5    # "jar":Ljava/util/jar/JarFile;
    .end local v7    # "nBytes":I
    .end local v8    # "out":Ljava/io/OutputStream;
    .end local v9    # "outfile":Ljava/io/File;
    :catch_0
    move-exception v3

    .line 259
    .local v3, "ex":Ljava/lang/Exception;
    invoke-virtual {v3}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1
.end method

.method private static createChildProcess(Landroid/content/Context;)V
    .locals 4
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 630
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v1

    iget-object v0, v1, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 633
    .local v0, "apkFilePath":Ljava/lang/String;
    invoke-static {}, Lcom/bangcle/protect/ACall;->getACall()Lcom/bangcle/protect/ACall;

    move-result-object v1

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    .line 634
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v3

    .line 633
    invoke-virtual {v1, v2, v3}, Lcom/bangcle/protect/ACall;->r1([B[B)V

    .line 639
    return-void
.end method

.method private static deleteDirectory(Ljava/io/File;)Z
    .locals 3
    .param p0, "path"    # Ljava/io/File;

    .prologue
    .line 264
    invoke-virtual {p0}, Ljava/io/File;->exists()Z

    move-result v2

    if-eqz v2, :cond_0

    .line 265
    invoke-virtual {p0}, Ljava/io/File;->listFiles()[Ljava/io/File;

    move-result-object v0

    .line 266
    .local v0, "files":[Ljava/io/File;
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    array-length v2, v0

    if-lt v1, v2, :cond_1

    .line 274
    .end local v0    # "files":[Ljava/io/File;
    .end local v1    # "i":I
    :cond_0
    invoke-virtual {p0}, Ljava/io/File;->delete()Z

    move-result v2

    return v2

    .line 267
    .restart local v0    # "files":[Ljava/io/File;
    .restart local v1    # "i":I
    :cond_1
    aget-object v2, v0, v1

    invoke-virtual {v2}, Ljava/io/File;->isDirectory()Z

    move-result v2

    if-eqz v2, :cond_2

    .line 268
    aget-object v2, v0, v1

    invoke-static {v2}, Lcom/bangcle/protect/Util;->deleteDirectory(Ljava/io/File;)Z

    .line 266
    :goto_1
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 270
    :cond_2
    aget-object v2, v0, v1

    invoke-virtual {v2}, Ljava/io/File;->delete()Z

    goto :goto_1
.end method

.method public static doCheck(Landroid/content/Context;)V
    .locals 15
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 656
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v9

    .line 657
    .local v9, "info":Landroid/content/pm/ApplicationInfo;
    new-instance v1, Ljava/io/File;

    iget-object v13, v9, Landroid/content/pm/ApplicationInfo;->dataDir:Ljava/lang/String;

    const-string v14, ".md5"

    invoke-direct {v1, v13, v14}, Ljava/io/File;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 659
    .local v1, "checkFile":Ljava/io/File;
    const-string v3, "/data/dalvik-cache/"

    .line 660
    .local v3, "dexPath":Ljava/lang/String;
    const/4 v5, 0x0

    .line 662
    .local v5, "dexResult":[B
    new-instance v4, Ljava/io/File;

    const-string v13, "/data/dalvik-cache/arm/"

    invoke-direct {v4, v13}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 663
    .local v4, "dexPathFile":Ljava/io/File;
    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v13

    if-eqz v13, :cond_0

    .line 664
    const-string v3, "/data/dalvik-cache/arm/"

    .line 668
    :cond_0
    new-instance v0, Ljava/lang/String;

    iget-object v13, v9, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    invoke-direct {v0, v13}, Ljava/lang/String;-><init>(Ljava/lang/String;)V

    .line 669
    .local v0, "apkPath":Ljava/lang/String;
    new-instance v11, Ljava/util/StringTokenizer;

    const-string v13, "/"

    invoke-direct {v11, v0, v13}, Ljava/util/StringTokenizer;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 671
    .local v11, "st":Ljava/util/StringTokenizer;
    :goto_0
    invoke-virtual {v11}, Ljava/util/StringTokenizer;->hasMoreTokens()Z

    move-result v13

    if-nez v13, :cond_3

    .line 677
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v14, "classes"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 678
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v14, ".dex"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 680
    const/4 v12, 0x0

    .line 682
    .local v12, "todo":Z
    :try_start_0
    invoke-static {v3}, Lcom/bangcle/protect/Util;->calFileMD5(Ljava/lang/String;)[B

    move-result-object v13

    invoke-static {v13}, Lcom/bangcle/protect/Util;->toASC([B)[B

    move-result-object v5

    .line 685
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v13

    if-nez v13, :cond_4

    .line 686
    if-eqz v5, :cond_1

    .line 687
    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 688
    .local v2, "chkOut":Ljava/io/FileOutputStream;
    invoke-virtual {v2, v5}, Ljava/io/FileOutputStream;->write([B)V

    .line 689
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 690
    const/4 v12, 0x1

    .line 712
    .end local v2    # "chkOut":Ljava/io/FileOutputStream;
    :cond_1
    :goto_1
    if-eqz v12, :cond_2

    .line 720
    new-instance v7, Ljava/io/File;

    new-instance v13, Ljava/lang/StringBuilder;

    const-string v14, "/data/data/"

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    const-string v14, "/.cache/"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-direct {v7, v13}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 721
    .local v7, "f":Ljava/io/File;
    invoke-static {v7}, Lcom/bangcle/protect/Util;->deleteDirectory(Ljava/io/File;)Z

    .line 723
    :try_start_1
    new-instance v2, Ljava/io/FileOutputStream;

    invoke-direct {v2, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 724
    .restart local v2    # "chkOut":Ljava/io/FileOutputStream;
    invoke-virtual {v2, v5}, Ljava/io/FileOutputStream;->write([B)V

    .line 725
    invoke-virtual {v2}, Ljava/io/FileOutputStream;->close()V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    .line 731
    .end local v2    # "chkOut":Ljava/io/FileOutputStream;
    .end local v7    # "f":Ljava/io/File;
    :cond_2
    :goto_2
    return-void

    .line 672
    .end local v12    # "todo":Z
    :cond_3
    sget-object v13, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v13}, Ljava/io/PrintStream;->println()V

    .line 673
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v11}, Ljava/util/StringTokenizer;->nextToken()Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 674
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-static {v3}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v14

    invoke-direct {v13, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const-string v14, "@"

    invoke-virtual {v13, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v13

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    goto/16 :goto_0

    .line 693
    .restart local v12    # "todo":Z
    :cond_4
    if-eqz v5, :cond_1

    .line 694
    :try_start_2
    invoke-static {v1}, Lcom/bangcle/protect/Util;->readFile(Ljava/io/File;)[B

    move-result-object v10

    .line 695
    .local v10, "md5":[B
    if-eqz v10, :cond_1

    .line 696
    array-length v13, v10

    array-length v14, v5

    if-ne v13, v14, :cond_6

    .line 697
    const/4 v8, 0x0

    .local v8, "i":I
    :goto_3
    array-length v13, v10

    if-ge v8, v13, :cond_1

    .line 698
    aget-byte v13, v10, v8

    aget-byte v14, v5, v8
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0

    if-eq v13, v14, :cond_5

    .line 699
    const/4 v12, 0x1

    .line 700
    goto :goto_1

    .line 697
    :cond_5
    add-int/lit8 v8, v8, 0x1

    goto :goto_3

    .line 704
    .end local v8    # "i":I
    :cond_6
    const/4 v12, 0x1

    goto :goto_1

    .line 709
    .end local v10    # "md5":[B
    :catch_0
    move-exception v6

    .line 710
    .local v6, "ex":Ljava/lang/Exception;
    sget-object v13, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v6, v13}, Ljava/lang/Exception;->printStackTrace(Ljava/io/PrintStream;)V

    goto/16 :goto_1

    .line 726
    .end local v6    # "ex":Ljava/lang/Exception;
    .restart local v7    # "f":Ljava/io/File;
    :catch_1
    move-exception v13

    goto :goto_2
.end method

.method public static doProvider()V
    .locals 2

    .prologue
    .line 57
    sget-object v1, Lcom/bangcle/protect/Util;->ps:Ljava/util/ArrayList;

    monitor-enter v1

    .line 59
    :try_start_0
    invoke-static {}, Lcom/bangcle/protect/ACall;->getACall()Lcom/bangcle/protect/ACall;

    move-result-object v0

    invoke-virtual {v0}, Lcom/bangcle/protect/ACall;->set4()V

    .line 57
    monitor-exit v1

    .line 61
    return-void

    .line 57
    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private static getAssetFile(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .locals 7
    .param p0, "context"    # Landroid/content/Context;
    .param p1, "source"    # Ljava/lang/String;
    .param p2, "dirstr"    # Ljava/lang/String;

    .prologue
    .line 161
    new-instance v1, Ljava/io/File;

    invoke-direct {v1, p2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 162
    .local v1, "dir":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v6

    if-nez v6, :cond_0

    .line 164
    :try_start_0
    invoke-virtual {v1}, Ljava/io/File;->createNewFile()Z

    .line 165
    invoke-virtual {p0}, Landroid/content/Context;->getAssets()Landroid/content/res/AssetManager;

    move-result-object v6

    invoke-virtual {v6, p1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;

    move-result-object v4

    .line 166
    .local v4, "is":Ljava/io/InputStream;
    new-instance v3, Ljava/io/FileOutputStream;

    invoke-direct {v3, v1}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 167
    .local v3, "fos":Ljava/io/FileOutputStream;
    const/16 v6, 0x1000

    new-array v0, v6, [B

    .line 168
    .local v0, "buffer":[B
    const/4 v5, 0x0

    .line 169
    .local v5, "len":I
    :goto_0
    invoke-virtual {v4, v0}, Ljava/io/InputStream;->read([B)I

    move-result v5

    const/4 v6, -0x1

    if-ne v5, v6, :cond_1

    .line 172
    invoke-virtual {v3}, Ljava/io/FileOutputStream;->close()V

    .line 173
    invoke-virtual {v4}, Ljava/io/InputStream;->close()V

    .line 179
    .end local v0    # "buffer":[B
    .end local v3    # "fos":Ljava/io/FileOutputStream;
    .end local v4    # "is":Ljava/io/InputStream;
    .end local v5    # "len":I
    :cond_0
    :goto_1
    return-void

    .line 170
    .restart local v0    # "buffer":[B
    .restart local v3    # "fos":Ljava/io/FileOutputStream;
    .restart local v4    # "is":Ljava/io/InputStream;
    .restart local v5    # "len":I
    :cond_1
    const/4 v6, 0x0

    invoke-virtual {v3, v0, v6, v5}, Ljava/io/FileOutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 174
    .end local v0    # "buffer":[B
    .end local v3    # "fos":Ljava/io/FileOutputStream;
    .end local v4    # "is":Ljava/io/InputStream;
    .end local v5    # "len":I
    :catch_0
    move-exception v2

    .line 175
    .local v2, "e":Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    .line 176
    invoke-virtual {v1}, Ljava/io/File;->delete()Z

    goto :goto_1
.end method

.method public static getCPUABI()Ljava/lang/String;
    .locals 7

    .prologue
    .line 847
    sget-object v5, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;

    if-nez v5, :cond_1

    .line 850
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v5

    .line 851
    const-string v6, "getprop ro.product.cpu.abi"

    .line 850
    invoke-virtual {v5, v6}, Ljava/lang/Runtime;->exec(Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v4

    .line 852
    .local v4, "process":Ljava/lang/Process;
    new-instance v3, Ljava/io/InputStreamReader;

    .line 853
    invoke-virtual {v4}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v5

    .line 852
    invoke-direct {v3, v5}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    .line 854
    .local v3, "ir":Ljava/io/InputStreamReader;
    new-instance v2, Ljava/io/BufferedReader;

    invoke-direct {v2, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 855
    .local v2, "input":Ljava/io/BufferedReader;
    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    .line 857
    .local v0, "abi":Ljava/lang/String;
    const-string v5, "x86"

    invoke-virtual {v0, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_0

    .line 858
    const-string v5, "x86"

    sput-object v5, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 866
    .end local v0    # "abi":Ljava/lang/String;
    .end local v2    # "input":Ljava/io/BufferedReader;
    .end local v3    # "ir":Ljava/io/InputStreamReader;
    :goto_0
    sget-object v5, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;

    .line 868
    :goto_1
    return-object v5

    .line 860
    .restart local v0    # "abi":Ljava/lang/String;
    .restart local v2    # "input":Ljava/io/BufferedReader;
    .restart local v3    # "ir":Ljava/io/InputStreamReader;
    :cond_0
    :try_start_1
    const-string v5, "arm"

    sput-object v5, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    .line 863
    .end local v0    # "abi":Ljava/lang/String;
    .end local v2    # "input":Ljava/io/BufferedReader;
    .end local v3    # "ir":Ljava/io/InputStreamReader;
    :catch_0
    move-exception v1

    .line 864
    .local v1, "ex":Ljava/lang/Exception;
    const-string v5, "arm"

    sput-object v5, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;

    goto :goto_0

    .line 868
    .end local v1    # "ex":Ljava/lang/Exception;
    .end local v4    # "process":Ljava/lang/Process;
    :cond_1
    sget-object v5, Lcom/bangcle/protect/Util;->CPUABI:Ljava/lang/String;

    goto :goto_1
.end method

.method public static getCPUinfo()Ljava/lang/String;
    .locals 9

    .prologue
    .line 373
    const-string v6, ""

    .line 376
    .local v6, "result":Ljava/lang/String;
    const/4 v7, 0x2

    :try_start_0
    new-array v0, v7, [Ljava/lang/String;

    const/4 v7, 0x0

    const-string v8, "/system/bin/cat"

    aput-object v8, v0, v7

    const/4 v7, 0x1

    const-string v8, "/proc/cpuinfo"

    aput-object v8, v0, v7

    .line 377
    .local v0, "args":[Ljava/lang/String;
    new-instance v1, Ljava/lang/ProcessBuilder;

    invoke-direct {v1, v0}, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V

    .line 379
    .local v1, "cmd":Ljava/lang/ProcessBuilder;
    invoke-virtual {v1}, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;

    move-result-object v4

    .line 380
    .local v4, "process":Ljava/lang/Process;
    invoke-virtual {v4}, Ljava/lang/Process;->getInputStream()Ljava/io/InputStream;

    move-result-object v3

    .line 381
    .local v3, "in":Ljava/io/InputStream;
    const/16 v7, 0x400

    new-array v5, v7, [B

    .line 382
    .local v5, "re":[B
    :goto_0
    invoke-virtual {v3, v5}, Ljava/io/InputStream;->read([B)I

    move-result v7

    const/4 v8, -0x1

    if-ne v7, v8, :cond_0

    .line 386
    invoke-virtual {v3}, Ljava/io/InputStream;->close()V

    .line 390
    .end local v0    # "args":[Ljava/lang/String;
    .end local v1    # "cmd":Ljava/lang/ProcessBuilder;
    .end local v3    # "in":Ljava/io/InputStream;
    .end local v4    # "process":Ljava/lang/Process;
    .end local v5    # "re":[B
    :goto_1
    return-object v6

    .line 384
    .restart local v0    # "args":[Ljava/lang/String;
    .restart local v1    # "cmd":Ljava/lang/ProcessBuilder;
    .restart local v3    # "in":Ljava/io/InputStream;
    .restart local v4    # "process":Ljava/lang/Process;
    .restart local v5    # "re":[B
    :cond_0
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-static {v6}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v8

    invoke-direct {v7, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    new-instance v8, Ljava/lang/String;

    invoke-direct {v8, v5}, Ljava/lang/String;-><init>([B)V

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v6

    goto :goto_0

    .line 387
    .end local v0    # "args":[Ljava/lang/String;
    .end local v1    # "cmd":Ljava/lang/ProcessBuilder;
    .end local v3    # "in":Ljava/io/InputStream;
    .end local v4    # "process":Ljava/lang/Process;
    .end local v5    # "re":[B
    :catch_0
    move-exception v2

    .line 388
    .local v2, "ex":Ljava/io/IOException;
    invoke-virtual {v2}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_1
.end method

.method private static getClassesJarSize(Landroid/content/Context;)J
    .locals 6
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 536
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v4

    iget-object v0, v4, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 537
    .local v0, "apkFilePath":Ljava/lang/String;
    new-instance v3, Ljava/util/jar/JarFile;

    invoke-direct {v3, v0}, Ljava/util/jar/JarFile;-><init>(Ljava/lang/String;)V

    .line 538
    .local v3, "jarFile":Ljava/util/jar/JarFile;
    const-string v4, "assets/bangcle_classes.jar"

    invoke-virtual {v3, v4}, Ljava/util/jar/JarFile;->getJarEntry(Ljava/lang/String;)Ljava/util/jar/JarEntry;

    move-result-object v2

    .line 539
    .local v2, "jarEntry":Ljava/util/jar/JarEntry;
    invoke-virtual {v2}, Ljava/util/jar/JarEntry;->getSize()J
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-wide v4

    .line 541
    .end local v0    # "apkFilePath":Ljava/lang/String;
    .end local v2    # "jarEntry":Ljava/util/jar/JarEntry;
    .end local v3    # "jarFile":Ljava/util/jar/JarFile;
    :goto_0
    return-wide v4

    .line 540
    :catch_0
    move-exception v1

    .line 541
    .local v1, "ex":Ljava/lang/Exception;
    const-wide/16 v4, 0x0

    goto :goto_0
.end method

.method public static getCustomClassLoader()Ljava/lang/ClassLoader;
    .locals 1

    .prologue
    .line 117
    sget-object v0, Lcom/bangcle/protect/Util;->cl:Ljava/lang/ClassLoader;

    return-object v0
.end method

.method private static getDataSize()J
    .locals 9

    .prologue
    .line 524
    invoke-static {}, Landroid/os/Environment;->getDataDirectory()Ljava/io/File;

    move-result-object v4

    .line 525
    .local v4, "data":Ljava/io/File;
    new-instance v5, Landroid/os/StatFs;

    invoke-virtual {v4}, Ljava/io/File;->getPath()Ljava/lang/String;

    move-result-object v8

    invoke-direct {v5, v8}, Landroid/os/StatFs;-><init>(Ljava/lang/String;)V

    .line 526
    .local v5, "fs":Landroid/os/StatFs;
    invoke-virtual {v5}, Landroid/os/StatFs;->getAvailableBlocks()I

    move-result v8

    int-to-long v0, v8

    .line 527
    .local v0, "availableBlocks":J
    invoke-virtual {v5}, Landroid/os/StatFs;->getBlockSize()I

    move-result v8

    int-to-long v6, v8

    .line 530
    .local v6, "size":J
    mul-long v2, v0, v6

    .line 531
    .local v2, "availableSize":J
    return-wide v2
.end method

.method public static getField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;
    .locals 5
    .param p1, "name"    # Ljava/lang/String;
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
    .line 806
    .local p0, "cls":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v2

    array-length v3, v2

    const/4 v1, 0x0

    :goto_0
    if-lt v1, v3, :cond_1

    .line 815
    const/4 v0, 0x0

    :cond_0
    return-object v0

    .line 806
    :cond_1
    aget-object v0, v2, v1

    .line 808
    .local v0, "field":Ljava/lang/reflect/Field;
    invoke-virtual {v0}, Ljava/lang/reflect/Field;->isAccessible()Z

    move-result v4

    if-nez v4, :cond_2

    .line 809
    const/4 v4, 0x1

    invoke-virtual {v0, v4}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 811
    :cond_2
    invoke-virtual {v0}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_0

    .line 806
    add-int/lit8 v1, v1, 0x1

    goto :goto_0
.end method

.method public static getFieldValue(Ljava/lang/Class;Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .locals 3
    .param p1, "obj"    # Ljava/lang/Object;
    .param p2, "name"    # Ljava/lang/String;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class",
            "<*>;",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            ")",
            "Ljava/lang/Object;"
        }
    .end annotation

    .prologue
    .line 820
    .local p0, "cls":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    :try_start_0
    invoke-static {p0, p2}, Lcom/bangcle/protect/Util;->getField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    .line 821
    .local v1, "f":Ljava/lang/reflect/Field;
    invoke-virtual {v1, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    move-result-object v2

    .line 826
    .end local v1    # "f":Ljava/lang/reflect/Field;
    :goto_0
    return-object v2

    .line 824
    :catch_0
    move-exception v0

    .line 825
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 826
    const/4 v2, 0x0

    goto :goto_0
.end method

.method private static isSpaceEnough(Landroid/content/Context;)Z
    .locals 11
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    const/4 v8, 0x1

    .line 546
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 547
    const-string v10, "/.cache/classes.jar"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 546
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    .line 548
    .local v3, "classesJarFileName":Ljava/lang/String;
    new-instance v9, Ljava/lang/StringBuilder;

    const-string v10, "/data/data/"

    invoke-direct {v9, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v10

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 549
    const-string v10, "/.cache/classes.dex"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v9

    .line 548
    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    .line 550
    .local v5, "dexFileName":Ljava/lang/String;
    new-instance v2, Ljava/io/File;

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 551
    .local v2, "classesJarFile":Ljava/io/File;
    new-instance v4, Ljava/io/File;

    invoke-direct {v4, v5}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 552
    .local v4, "dexFile":Ljava/io/File;
    invoke-virtual {v2}, Ljava/io/File;->exists()Z

    move-result v9

    if-eqz v9, :cond_1

    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v9

    if-eqz v9, :cond_1

    .line 561
    :cond_0
    :goto_0
    return v8

    .line 555
    :cond_1
    invoke-static {}, Lcom/bangcle/protect/Util;->getDataSize()J

    move-result-wide v6

    .line 556
    .local v6, "size":J
    invoke-static {p0}, Lcom/bangcle/protect/Util;->getClassesJarSize(Landroid/content/Context;)J

    move-result-wide v0

    .line 558
    .local v0, "classSize":J
    const-wide/16 v9, 0x4

    mul-long/2addr v9, v0

    cmp-long v9, v9, v6

    if-lez v9, :cond_0

    .line 559
    const/4 v8, 0x0

    goto :goto_0
.end method

.method public static readFile(Ljava/io/File;)[B
    .locals 5
    .param p0, "path"    # Ljava/io/File;
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .prologue
    .line 745
    new-instance v1, Ljava/io/FileInputStream;

    invoke-direct {v1, p0}, Ljava/io/FileInputStream;-><init>(Ljava/io/File;)V

    .line 746
    .local v1, "input":Ljava/io/FileInputStream;
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 747
    .local v2, "out":Ljava/io/ByteArrayOutputStream;
    const v4, 0x8000

    new-array v0, v4, [B

    .line 748
    .local v0, "buffer":[B
    const/4 v3, 0x0

    .line 749
    .local v3, "readed":I
    :goto_0
    invoke-virtual {v1, v0}, Ljava/io/FileInputStream;->read([B)I

    move-result v3

    if-gtz v3, :cond_0

    .line 752
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v4

    return-object v4

    .line 750
    :cond_0
    const/4 v4, 0x0

    invoke-virtual {v2, v0, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0
.end method

.method private static readVersions(Ljava/io/File;)[Ljava/lang/String;
    .locals 5
    .param p0, "f"    # Ljava/io/File;

    .prologue
    .line 298
    :try_start_0
    new-instance v2, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/FileReader;

    invoke-direct {v3, p0}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v2, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 299
    .local v2, "reader":Ljava/io/BufferedReader;
    const/4 v3, 0x2

    new-array v1, v3, [Ljava/lang/String;

    .line 300
    .local v1, "lines":[Ljava/lang/String;
    const/4 v3, 0x0

    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v1, v3

    .line 301
    const/4 v3, 0x1

    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    aput-object v4, v1, v3

    .line 303
    invoke-virtual {v2}, Ljava/io/BufferedReader;->close()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 308
    .end local v1    # "lines":[Ljava/lang/String;
    .end local v2    # "reader":Ljava/io/BufferedReader;
    :goto_0
    return-object v1

    .line 305
    :catch_0
    move-exception v0

    .line 307
    .local v0, "e":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 308
    const/4 v1, 0x0

    goto :goto_0
.end method

.method public static realCopy(Ljava/lang/String;Ljava/util/jar/JarFile;Ljava/util/zip/ZipEntry;)V
    .locals 7
    .param p0, "destFileName"    # Ljava/lang/String;
    .param p1, "jar"    # Ljava/util/jar/JarFile;
    .param p2, "entry"    # Ljava/util/zip/ZipEntry;

    .prologue
    .line 396
    :try_start_0
    new-instance v5, Ljava/io/File;

    invoke-direct {v5, p0}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 397
    .local v5, "outfile":Ljava/io/File;
    const/high16 v6, 0x10000

    new-array v0, v6, [B

    .line 398
    .local v0, "buffer":[B
    new-instance v2, Ljava/io/BufferedInputStream;

    invoke-virtual {p1, p2}, Ljava/util/jar/JarFile;->getInputStream(Ljava/util/zip/ZipEntry;)Ljava/io/InputStream;

    move-result-object v6

    invoke-direct {v2, v6}, Ljava/io/BufferedInputStream;-><init>(Ljava/io/InputStream;)V

    .line 399
    .local v2, "in":Ljava/io/InputStream;
    new-instance v4, Ljava/io/BufferedOutputStream;

    new-instance v6, Ljava/io/FileOutputStream;

    .line 400
    invoke-direct {v6, v5}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V

    .line 399
    invoke-direct {v4, v6}, Ljava/io/BufferedOutputStream;-><init>(Ljava/io/OutputStream;)V

    .line 403
    .local v4, "out":Ljava/io/OutputStream;
    :goto_0
    invoke-virtual {v2, v0}, Ljava/io/InputStream;->read([B)I

    move-result v3

    .line 405
    .local v3, "nBytes":I
    if-gtz v3, :cond_0

    .line 409
    invoke-virtual {v4}, Ljava/io/OutputStream;->flush()V

    .line 410
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V

    .line 411
    invoke-virtual {v2}, Ljava/io/InputStream;->close()V

    .line 415
    .end local v0    # "buffer":[B
    .end local v2    # "in":Ljava/io/InputStream;
    .end local v3    # "nBytes":I
    .end local v4    # "out":Ljava/io/OutputStream;
    .end local v5    # "outfile":Ljava/io/File;
    :goto_1
    return-void

    .line 407
    .restart local v0    # "buffer":[B
    .restart local v2    # "in":Ljava/io/InputStream;
    .restart local v3    # "nBytes":I
    .restart local v4    # "out":Ljava/io/OutputStream;
    .restart local v5    # "outfile":Ljava/io/File;
    :cond_0
    const/4 v6, 0x0

    invoke-virtual {v4, v0, v6, v3}, Ljava/io/OutputStream;->write([BII)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 412
    .end local v0    # "buffer":[B
    .end local v2    # "in":Ljava/io/InputStream;
    .end local v3    # "nBytes":I
    .end local v4    # "out":Ljava/io/OutputStream;
    .end local v5    # "outfile":Ljava/io/File;
    :catch_0
    move-exception v1

    .line 413
    .local v1, "ex":Ljava/lang/Exception;
    invoke-virtual {v1}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_1
.end method

.method public static runAll(Landroid/content/Context;)V
    .locals 4
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 784
    sput-object p0, Lcom/bangcle/protect/Util;->x86Ctx:Landroid/content/Context;

    .line 785
    invoke-static {p0}, Lcom/bangcle/protect/Util;->doCheck(Landroid/content/Context;)V

    .line 786
    invoke-static {p0}, Lcom/bangcle/protect/Util;->checkUpdate(Landroid/content/Context;)V

    .line 789
    :try_start_0
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/.cache/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 790
    .local v1, "f":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    .line 791
    invoke-virtual {v1}, Ljava/io/File;->mkdir()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 796
    .end local v1    # "f":Ljava/io/File;
    :cond_0
    :goto_0
    invoke-static {p0}, Lcom/bangcle/protect/Util;->checkX86(Landroid/content/Context;)V

    .line 800
    invoke-static {p0}, Lcom/bangcle/protect/Util;->CopyBinaryFile(Landroid/content/Context;)V

    .line 801
    invoke-static {p0}, Lcom/bangcle/protect/Util;->createChildProcess(Landroid/content/Context;)V

    .line 802
    invoke-static {p0}, Lcom/bangcle/protect/Util;->tryDo(Landroid/content/Context;)V

    .line 803
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-static {p0, v2}, Lcom/bangcle/protect/Util;->runPkg(Landroid/content/Context;Ljava/lang/String;)V

    .line 804
    return-void

    .line 793
    :catch_0
    move-exception v0

    .line 794
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static runAll1(Landroid/content/Context;)V
    .locals 4
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 773
    :try_start_0
    new-instance v1, Ljava/io/File;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    const-string v3, "/.cache/"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {v1, v2}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    .line 774
    .local v1, "f":Ljava/io/File;
    invoke-virtual {v1}, Ljava/io/File;->exists()Z

    move-result v2

    if-nez v2, :cond_0

    .line 775
    invoke-virtual {v1}, Ljava/io/File;->mkdir()Z
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 780
    .end local v1    # "f":Ljava/io/File;
    :cond_0
    :goto_0
    invoke-static {p0}, Lcom/bangcle/protect/Util;->checkX86(Landroid/content/Context;)V

    .line 781
    return-void

    .line 777
    :catch_0
    move-exception v0

    .line 778
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method private static runPkg(Landroid/content/Context;Ljava/lang/String;)V
    .locals 6
    .param p0, "ctx"    # Landroid/content/Context;
    .param p1, "pkgName"    # Ljava/lang/String;

    .prologue
    .line 123
    :try_start_0
    sget-object v1, Lcom/bangcle/protect/Util;->cl:Ljava/lang/ClassLoader;

    if-nez v1, :cond_0

    .line 125
    sget-boolean v1, Lcom/bangcle/protect/Util;->isX86:Z

    if-eqz v1, :cond_1

    .line 132
    new-instance v1, Lcom/bangcle/protect/MyClassLoader;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 133
    const-string v3, "/.cache/classes.jar"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "/data/data/"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 134
    const-string v4, "/.cache"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "/data/data/"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "/lib/"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 135
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v5

    .line 132
    invoke-direct {v1, v2, v3, v4, v5}, Lcom/bangcle/protect/MyClassLoader;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/ClassLoader;)V

    sput-object v1, Lcom/bangcle/protect/Util;->cl:Ljava/lang/ClassLoader;

    .line 157
    :cond_0
    :goto_0
    return-void

    .line 143
    :cond_1
    new-instance v1, Lcom/bangcle/protect/MyClassLoader;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "/data/data/"

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    .line 144
    const-string v3, "/.cache/classes.jar"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "/data/data/"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    .line 145
    const-string v4, "/.cache"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "/data/data/"

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    const-string v5, "/lib/"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    .line 146
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v5

    .line 143
    invoke-direct {v1, v2, v3, v4, v5}, Lcom/bangcle/protect/MyClassLoader;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/ClassLoader;)V

    sput-object v1, Lcom/bangcle/protect/Util;->cl:Ljava/lang/ClassLoader;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 152
    :catch_0
    move-exception v0

    .line 153
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static setFieldValue(Ljava/lang/Class;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V
    .locals 5
    .param p1, "obj"    # Ljava/lang/Object;
    .param p2, "name"    # Ljava/lang/String;
    .param p3, "value"    # Ljava/lang/Object;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Class",
            "<*>;",
            "Ljava/lang/Object;",
            "Ljava/lang/String;",
            "Ljava/lang/Object;",
            ")V"
        }
    .end annotation

    .prologue
    .line 831
    .local p0, "cls":Ljava/lang/Class;, "Ljava/lang/Class<*>;"
    sget-object v2, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "setFieldValue"

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v2, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 832
    if-nez p2, :cond_0

    .line 842
    :goto_0
    return-void

    .line 834
    :cond_0
    :try_start_0
    invoke-static {p0, p2}, Lcom/bangcle/protect/Util;->getField(Ljava/lang/Class;Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    .line 835
    .local v1, "f":Ljava/lang/reflect/Field;
    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 836
    invoke-virtual {v1, p1, p3}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    .line 839
    .end local v1    # "f":Ljava/lang/reflect/Field;
    :catch_0
    move-exception v0

    .line 840
    .local v0, "ex":Ljava/lang/Exception;
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    goto :goto_0
.end method

.method public static toASC([B)[B
    .locals 6
    .param p0, "bts"    # [B

    .prologue
    .line 735
    array-length v3, p0

    mul-int/lit8 v3, v3, 0x2

    new-array v2, v3, [B

    .line 736
    .local v2, "ret":[B
    const/4 v1, 0x0

    .local v1, "i":I
    :goto_0
    array-length v3, p0

    if-lt v1, v3, :cond_0

    .line 741
    return-object v2

    .line 737
    :cond_0
    aget-byte v0, p0, v1

    .line 738
    .local v0, "b":B
    mul-int/lit8 v3, v1, 0x2

    sget-object v4, Lcom/bangcle/protect/Util;->hexDigits:[B

    shr-int/lit8 v5, v0, 0x4

    and-int/lit8 v5, v5, 0xf

    aget-byte v4, v4, v5

    aput-byte v4, v2, v3

    .line 739
    mul-int/lit8 v3, v1, 0x2

    add-int/lit8 v3, v3, 0x1

    sget-object v4, Lcom/bangcle/protect/Util;->hexDigits:[B

    and-int/lit8 v5, v0, 0xf

    aget-byte v4, v4, v5

    aput-byte v4, v2, v3

    .line 736
    add-int/lit8 v1, v1, 0x1

    goto :goto_0
.end method

.method private static tryDo(Landroid/content/Context;)V
    .locals 5
    .param p0, "ctx"    # Landroid/content/Context;

    .prologue
    .line 642
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v1

    iget-object v0, v1, Landroid/content/pm/ApplicationInfo;->sourceDir:Ljava/lang/String;

    .line 646
    .local v0, "apkFilePath":Ljava/lang/String;
    invoke-static {}, Lcom/bangcle/protect/ACall;->getACall()Lcom/bangcle/protect/ACall;

    move-result-object v1

    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    .line 647
    invoke-virtual {v0}, Ljava/lang/String;->getBytes()[B

    move-result-object v3

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationInfo()Landroid/content/pm/ApplicationInfo;

    move-result-object v4

    iget-object v4, v4, Landroid/content/pm/ApplicationInfo;->processName:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->getBytes()[B

    move-result-object v4

    .line 646
    invoke-virtual {v1, v2, v3, v4}, Lcom/bangcle/protect/ACall;->r2([B[B[B)V

    .line 652
    return-void
.end method

.method private static writeVersion(Ljava/io/File;ILjava/lang/String;)V
    .locals 4
    .param p0, "f"    # Ljava/io/File;
    .param p1, "versionCode"    # I
    .param p2, "versionName"    # Ljava/lang/String;

    .prologue
    .line 280
    :try_start_0
    new-instance v0, Ljava/io/BufferedWriter;

    new-instance v3, Ljava/io/FileWriter;

    invoke-direct {v3, p0}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-direct {v0, v3}, Ljava/io/BufferedWriter;-><init>(Ljava/io/Writer;)V

    .line 281
    .local v0, "bw":Ljava/io/BufferedWriter;
    invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;

    move-result-object v2

    .line 282
    .local v2, "vcode":Ljava/lang/String;
    invoke-virtual {v0, v2}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 283
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->newLine()V

    .line 284
    invoke-virtual {v0, p2}, Ljava/io/BufferedWriter;->write(Ljava/lang/String;)V

    .line 285
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->flush()V

    .line 286
    invoke-virtual {v0}, Ljava/io/BufferedWriter;->close()V
    :try_end_0
    .catch Ljava/io/IOException; {:try_start_0 .. :try_end_0} :catch_0

    .line 292
    .end local v0    # "bw":Ljava/io/BufferedWriter;
    .end local v2    # "vcode":Ljava/lang/String;
    :goto_0
    return-void

    .line 287
    :catch_0
    move-exception v1

    .line 289
    .local v1, "e":Ljava/io/IOException;
    invoke-virtual {v1}, Ljava/io/IOException;->printStackTrace()V

    goto :goto_0
.end method

boolean doSave=false;
boolean saveAsPDF=false;

String SAVE_NAME = newSessionID();

int FPS=25;
int MAX_EXPORT_DURATION=1000;

int frameRec;

MovieMaker mm;

void checkSave() {
  if (doSave) {
    if (saveAsPDF) {
      endRaw();
      doSave=false;
      println(SAVE_NAME+"-"+(int)(System.currentTimeMillis()*0.001));
    }
    else {
      if (mm==null) {
        mm = new MovieMaker(this,width,height,SAVE_NAME+"-"+(int)(System.currentTimeMillis()*0.001)+".mov",FPS, MovieMaker.ANIMATION, MovieMaker.LOSSLESS);
        frameRec=0;
        println("recording...");
      }
      loadPixels();
      mm.addFrame(pixels,width,height);
      if (++frameRec>=MAX_EXPORT_DURATION*FPS) {
        finishExport();
        exit();
      }
    }
  }
}

void checkSaveKey() {
  if (key==32) {
    doSave=!doSave;
    if (!doSave && mm!=null) {
      finishExport();
    }
  }
}

void finishExport() {
  mm.finish();
  mm=null;
  println("stopped...");
  doSave=false;
}

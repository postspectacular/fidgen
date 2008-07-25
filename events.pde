void keyPressed() {
  key|=0x20; // ignore upper/lower case
  if (key=='x') {
    discardMarker();
  } 
  else if(key=='p') {
    showPhysics=!showPhysics;
  } 
  else if(key=='d') {
    showDebug=!showDebug;
  } 
  else if (key=='s') {
    saveTrees();
  }
  else if (key=='a') {
    newFid=true;
  } 
  else if (key=='i') {
    isInverted=!isInverted;
  }
  else if (key=='h') {
    showDepthSequence=!showDepthSequence;
  }
  else if (key=='n') {
     newSession();
  } 
  else if (key=='l') {
    showFiducialID=!showFiducialID;
  }
  checkSaveKey();
}

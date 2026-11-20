#!/bin/bash
SRC_PACK=`ls *.exe`
if [ -f "$SRC_PACK" ]; then
  DST_PACK=GoogleChrome_X64_Laster.7z
  if [ -d Chrome-bin ]; then
    rm -rf Chrome-bin
  fi
  if [ -d Chrome ]; then
    rm -rf Chrome
  fi
  if [ -f "$DST_PACK" ]; then
    rm -f "$DST_PACK"
  fi
  /builds/worker/fetches/7zz/7zz x "$SRC_PACK"
  if [ -d Chrome-bin ]; then
    mkdir -p Chrome/App
    mv Chrome-bin/* Chrome/App
    if [ -f "Chrome/App/chrome.exe" ] && [ -f "msedge64++.7z" ]; then
      CC_VER=`ls -l Chrome/App | grep '^d' | awk '{print $9}'`
      /builds/worker/fetches/7zz/7zz x msedge64++.7z -OChrome/App/$CC_VER
      if [ -f "Chrome/App/$CC_VER/injectpe.bat" ]; then
        export WINEPREFIX=/builds/worker/fetches/.wine
        /builds/worker/fetches/wine/bin/wine cmd.exe /c Chrome/App/$CC_VER/injectpe.bat -chrome -auto
        /builds/worker/fetches/7zz/7zz a "$DST_PACK" Chrome -mx9 -t7z
        rm -d Chrome-bin
        rm -f msedge64++.7z
        rm -f "$SRC_PACK"
      fi
    fi
  fi
fi

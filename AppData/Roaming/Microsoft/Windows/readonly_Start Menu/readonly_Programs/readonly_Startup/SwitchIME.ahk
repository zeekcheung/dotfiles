#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; Add process names that require English mode here
EnglishApps := [
  "acad.exe",
  "cmd.exe",
  "code.exe",
  "conhost.exe",
  "devenv.exe",
  "neovide.exe",
  "obsidian.exe",
  "powershell.exe",
  "pwsh.exe",
  "rider64.exe",
  "ugraf.exe",
  "windowsterminal.exe",
  "wt.exe",
  "zed.exe",
]

; Register Shell Hook to monitor window events
MsgNum := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
DllCall("RegisterShellHookWindow", "Ptr", A_ScriptHwnd)
OnMessage(MsgNum, ShellMessage)

ShellMessage(wParam, lParam, *) {
  ; wParam: 1 (HSHELL_WINDOWCREATED), 4 (HSHELL_WINDOWACTIVATED), 32772 (HSHELL_RUDEAPPACTIVATED)
  if (wParam = 1 || wParam = 4 || wParam = 32772) {
    try {
      processName := WinGetProcessName("ahk_id " . lParam)

      isEnglish := false
      for app in EnglishApps {
        if (processName = app) {
          isEnglish := true
          break
        }
      }

      ; 0x50 is WM_INPUTLANGCHANGEREQUEST
      ; 0x4090409 corresponds to English (United States)
      ; 0x8040804 corresponds to Chinese (Simplified, China)
      if (isEnglish) {
        PostMessage(0x50, 0, 0x4090409, , "ahk_id " . lParam)
      } else {
        PostMessage(0x50, 0, 0x8040804, , "ahk_id " . lParam)
      }
    }
  }
}


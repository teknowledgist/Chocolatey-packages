;install
SetTitleMatchMode, RegEx
winWait, Bio-Rad KnowItAll [\d\.]+ Setup
ControlClick, I &accept, Bio-Rad KnowItAll [\d\.]+ Setup
ControlClick, &Next, Bio-Rad KnowItAll [\d\.]+ Setup
WinWait, Bio-Rad KnowItAll [\d\.]+ Setup, Click the "Finish" button
ControlClick, &Finish, Bio-Rad KnowItAll [\d\.]+ Setup


;register
run, "C:\Program Files\KnowItAll\Bin\KnowItAll.exe"
SetTitleMatchMode, 1
winWait, Product Registration, KnowItAll
ControlClick, Edit1, Product Registration, KnowItAll
Send, ^a<Your Name here>
ControlClick, Edit2, Product Registration, KnowItAll
Send, ^a<Your email address here>
ControlClick, Edit3, Product Registration, KnowItAll
Send, ^<Registration code here>
ControlClick, Button1, Product Registration, KnowItAll

;close
WinWait, BrowseIt - KnowItAll
WinClose, BrowseIt - KnowItAll
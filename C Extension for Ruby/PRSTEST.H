/*----------------------------------------------------------------------------s
	NAME
		PRSTEST.

	PURPOSE
		This demo shows how to use Wintab to detect/display pen pressure input.

	COPYRIGHT
		Copyright (C) 1998  LCS/Telegraphics
		Copyright (c) Wacom Company, Ltd. 2010 All Rights Reserved
		All rights reserved.

	AUTHORS
		RICO 4/1/92
		RCohn 3/2/2010
---------------------------------------------------------------------------- */

#define IDM_ABOUT 100

int PASCAL WinMain(HINSTANCE, HINSTANCE, LPSTR, int);
BOOL InitApplication(HANDLE);
BOOL InitInstance(HANDLE, int);
LRESULT FAR PASCAL MainWndProc(HWND, unsigned, WPARAM, LPARAM);
BOOL FAR PASCAL About(HWND, unsigned, WPARAM, LPARAM);
void Cleanup( void );

/*
 * $Id$
 */

/*
 * Harbour Project source code:
 * The Debugger Browser
 *
 * Copyright 2004 Ryszard Glab <rglab@imid.med.pl>
 * www - http://www.harbour-project.org
 * Copyright 2007 Phil Krylov <phil a t newstar.rinet.ru>
 * www - http://xharbour.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */

#include "hbclass.ch"

/* HBDbBrowser
 *
 * A minimalistic TBrowse implementation just enough for use in
 * the debugger instead of the HBBrowse monster
 */
CREATE CLASS HBDbBrowser

   VAR Window
   VAR cargo
   
   VAR nTop
   VAR nLeft
   VAR nBottom
   VAR nRight
   VAR colorSpec
   VAR autoLite INIT .T.

   VAR goTopBlock
   VAR goBottomBlock
   VAR skipBlock

   VAR stable INIT .F.
   VAR rowCount INIT 0
   VAR rowPos INIT 1
   VAR colCount INIT 0
   VAR colPos INIT 1
   VAR hitBottom INIT .F.
   VAR freeze INIT 0

   VAR aColumns INIT {}
   VAR aRowState INIT {}
   VAR aColorSpec INIT {}
   VAR nFirstVisible INIT 1
   VAR lConfigured INIT .F.

   METHOD New( nTop, nLeft, nBottom, nRight, oParentWindow )
   METHOD AddColumn( oCol )    INLINE AAdd( ::aColumns, oCol ), ::colCount++, Self
   METHOD Configure()
   METHOD DeHiLite()           INLINE Self
   METHOD Down()               INLINE ::MoveCursor( 1 )
   METHOD ForceStable()
   METHOD GetColumn( nColumn ) INLINE ::aColumns[ nColumn ]
   METHOD GoTo( nRow )
   METHOD GoTop()              INLINE ::GoTo( 1 ), ::rowPos := 1, ::nFirstVisible := 1, ::RefreshAll()
   METHOD GoBottom()
   METHOD HiLite()             INLINE Self
   METHOD Invalidate()         INLINE ::RefreshAll()
   METHOD MoveCursor( nSkip )
   METHOD PageDown()           INLINE ::MoveCursor( ::rowCount )
   METHOD PageUp()             INLINE ::MoveCursor( -::rowCount )
   METHOD RefreshAll()         INLINE AFill( ::aRowState, .F. ), Self
   METHOD RefreshCurrent()     INLINE IIf( ::rowCount > 0, ::aRowState[ ::rowPos ] := .F., ), Self
   METHOD Resize( nTop, nLeft, nBottom, nRight )
   METHOD Stabilize()          INLINE ::ForceStable()
   METHOD Up()                 INLINE ::MoveCursor( -1 )

ENDCLASS

METHOD New( nTop, nLeft, nBottom, nRight, oParentWindow ) CLASS HBDbBrowser

   ::Window := oParentWindow
   ::nTop := nTop
   ::nLeft := nLeft
   ::nBottom := nBottom
   ::nRight := nRight
   
   RETURN Self

METHOD Configure()
   ::rowCount := ::nBottom - ::nTop + 1
   ASize( ::aRowState, ::rowCount )
   ::aColorSpec := hb_aTokens( ::colorSpec, "," )
   ::lConfigured := .T.
   RETURN Self

METHOD MoveCursor( nSkip )
   LOCAL nSkipped

   nSkipped := ::GoTo( ::rowPos + ::nFirstVisible - 1 + nSkip )
   IF !::hitBottom .OR. Abs( nSkipped ) > 0
      IF IIf( nSkipped > 0, ::rowPos + nSkipped <= ::rowCount, ::rowPos + nSkipped >= 1 )
         ::RefreshCurrent()
         ::rowPos += nSkipped
         ::RefreshCurrent()
      ELSE
         ::nFirstVisible := Max( 1, nSkipped + ::nFirstVisible )
         ::RefreshAll()
      ENDIF
   ENDIF
   RETURN Self

METHOD ForceStable()
   LOCAL nRow, nCol, xData, oCol, nColX, nWid, aClr, nClr

   IF !::lConfigured
       ::Configure()
   ENDIF
   FOR nRow := 1 TO ::rowCount
      IF Empty( ::aRowState[ nRow ] )
         ::GoTo( ::nFirstVisible + nRow - 1 )
         IF ::hitBottom
            DispOutAt( ::nTop + nRow - 1, ::nLeft, Space( ::nRight - ::nLeft + 1 ), ::aColorSpec[ 1 ] )
         ELSE
            nColX := ::nLeft
            FOR nCol := 1 TO Len( ::aColumns )
               IF nColX <= ::nRight
                  oCol := ::aColumns[ nCol ]
                  xData := Eval( oCol:block )
                  nClr := IIf( nRow == ::rowPos, 2, 1 )
                  aClr := Eval( oCol:colorBlock, xData )
                  IF VALTYPE( aClr ) == "A"
                     nClr := aClr[ nClr ]
                  ELSE
                     nClr := oCol:defColor[ nClr ]
                  ENDIF
                  IF oCol:width == NIL
                     nWid := Len( xData )
                  ELSE
                     nWid := oCol:width
                  ENDIF
                  DispOutAt( ::nTop + nRow - 1, nColX, PadR( xData, nWid ) + IIf( nCol < Len( ::aColumns ), " ", "" ), ::aColorSpec[ nClr ] )
                  nColX += nWid + 1
               ENDIF
            NEXT
         ENDIF
         ::aRowState[ nRow ] := .T.
      ENDIF
   NEXT
   ::GoTo( ::nFirstVisible + ::rowPos - 1 )
   SetPos( ::nTop + ::rowPos - 1, ::nLeft )
   RETURN Self

METHOD GoTo( nRow )
   LOCAL nOldRow := ::nFirstVisible + ::rowPos - 1
   LOCAL nSkipped := 0

   Eval( ::goTopBlock )
   IF nRow == 1
      ::hitBottom := .F.
   ELSE
      nSkipped := Eval( ::skipBlock, nRow - 1 )
      ::hitBottom := ( nSkipped != nRow - 1 )
   ENDIF
   RETURN nSkipped - nOldRow + 1

METHOD GoBottom()
   DO WHILE !::hitBottom
      ::PageDown()
   ENDDO
   RETURN Self

METHOD Resize( nTop, nLeft, nBottom, nRight )
   LOCAL lResize := .F.

   IF nTop != NIL .AND. nTop != ::nTop
      ::nTop := nTop
      lResize := .T.
   ENDIF
   IF nLeft != NIL .AND. nLeft != ::nLeft
      ::nLeft := nLeft
      lResize := .T.
   ENDIF
   IF nBottom != NIL .AND. nBottom != ::nBottom
      ::nBottom := nBottom
      lResize := .T.
   ENDIF
   IF nRight != NIL .AND. nRight != ::nRight
      ::nRight := nRight
      lResize := .T.
   ENDIF

   IF lResize
      ::Configure():ForceStable()
   ENDIF
      
   RETURN self
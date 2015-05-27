#tag Module
Protected Module StringHelper
	#tag Method, Flags = &h0
		Function FormatDecimal(Extends value As Single) As String
		  Return Format(value, "-###,###,##0.00")

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDollar(Extends value As Single, padWidth as Integer = 0) As String
		  dim formatted as String = Format(value, "-###,###,##0.00")

		  if padWidth > 0 then
		    formatted = formatted.PadRight(padWidth)
		  end if

		  return "$" + formatted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatInteger(Extends value As Currency, truncate As Boolean = False) As String
		  If truncate Then
		    value = Floor(value)
		  End If

		  Return Format(value, "-###,###,##0")

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatInteger(Extends value As Double, truncate As Boolean = False) As String
		  If truncate Then
		    value = Floor(value)
		  End If

		  Return Format(value, "-###,###,##0")

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatInteger(Extends value As Integer) As String
		  Return Format(value, "-###,###,##0")

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatInteger(Extends value As Single, truncate As Boolean = False) As String
		  If truncate Then
		    value = Floor(value)
		  End If

		  Return Format(value, "-###,###,##0")

		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatPercent(Extends value As Double, shouldRound As Boolean = False) As String
		  value = value * 100.0

		  if shouldRound then
		    dim iValue as Integer = Round(value)

		    return Format(iValue, "###") + "%"

		  else
		    return Format(value, "###.0#") + "%"
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PadRight(Extends value As String, size As Integer, padWith As String = " ") As String
		  If value.Len > size Then
		    Return value.Left(size)
		  End If

		  Dim diff As Integer = size - value.Len
		  Dim padVal() As String
		  ReDim padVal(diff)

		  Return Join(padVal, padWith) + value
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule

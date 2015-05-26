#tag Module
Protected Module StringHelper
	#tag Method, Flags = &h0
		Function CamelToUnder(Extends camel As String) As String
		  Static CamelCache As New Dictionary
		  
		  If CamelCache.HasKey(camel) Then
		    Return CamelCache.Value(camel)
		  End If
		  
		  Dim result() As String
		  Dim start As Integer = 1
		  Dim camelLen As Integer = camel.Len
		  Dim lastWasNumber As Boolean = False
		  
		  For i As Integer = 2 To camelLen
		    Dim asciiValue As Integer = camel.Mid(i, 1).Asc
		    If asciiValue >= 48 And asciiValue <= 57 Then
		      If lastWasNumber Then
		        ' Do nothing
		      Else
		        lastWasNumber = True
		        result.Append camel.Mid(start, i - start).Lowercase
		        start = i
		      End If
		    ElseIf asciiValue >= 65 And asciiValue <= 90 Then
		      lastWasNumber = False
		      result.Append camel.Mid(start, i - start).Lowercase
		      start = i
		    Else
		      lastWasNumber = False
		    End If
		  Next
		  
		  result.Append camel.Mid(start).Lowercase
		  
		  Dim r As String = Join(result, "_")
		  CamelCache.Value(camel) = r
		  
		  Return r
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrencyValue(Extends s As String) As Currency
		  Return Val(s.ReplaceAll(",", "").ReplaceAll("$", "").ReplaceAll("%", ""))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDecimal(Extends value As Currency) As String
		  Return Format(value, "-###,###,##0.00")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDecimal(Extends value As Double) As String
		  Return Format(value, "-###,###,##0.00")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDecimal(Extends value As Integer) As String
		  Return Format(value, "-###,###,##0.00")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDecimal(Extends value As Single) As String
		  Return Format(value, "-###,###,##0.00")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDecimalSql(extends value as Double) As String
		  return Format(value, "-#.00")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDollar(Extends value As Currency, padWidth as Integer = 0) As String
		  dim formatted as String = Format(value, "-###,###,##0.00")
		  
		  if padWidth > 0 then
		    formatted = formatted.PadRight(padWidth)
		  end if
		  
		  return "$" + formatted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDollar(Extends value As Double, padWidth as Integer = 0) As String
		  dim formatted as String = Format(value, "-###,###,##0.00")
		  
		  if padWidth > 0 then
		    formatted = formatted.PadRight(padWidth)
		  end if
		  
		  return "$" + formatted
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FormatDollar(Extends value As Integer, padWidth as Integer = 0) As String
		  dim formatted as String = Format(value, "-###,###,##0.00")
		  
		  if padWidth > 0 then
		    formatted = formatted.PadRight(padWidth)
		  end if
		  
		  return "$" + formatted
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
		Function FormatFileSize(fileSize As Double) As String
		  //
		  // Conversion factors and abbreviations are New IEC Standard
		  // http://www.t1shopper.com/tools/calculate/filesizedescription.shtml
		  //
		  
		  Dim fileSizeSuffix As String
		  Dim fileSizeDivisor As Double
		  
		  Select Case fileSize
		  Case Is <= 1024.0
		    // Byte
		    fileSizeDivisor = 0.0
		    fileSizeSuffix = "b"
		    
		  Case Is <= 1048576.0
		    // Kilobyte
		    fileSizeDivisor = 1024.0
		    fileSizeSuffix = "kB"
		    
		  Case Is <= 1073741824.0
		    // Megabyte
		    fileSizeDivisor = 1048576.0
		    fileSizeSuffix = "MB"
		    
		  Case Is <= 1099511627776.0
		    // Gigabyte
		    fileSizeDivisor = 1073741824.0
		    fileSizeSuffix = "GB"
		    
		  Case Is <= 1125899906842624.0
		    // Terabyte
		    fileSizeDivisor = 1099511627776.0
		    fileSizeSuffix = "TB"
		    
		  Case Is <= 1152921504606846976.0
		    // Petabyte
		    fileSizeDivisor = 1125899906842624.0
		    fileSizeSuffix = "PB"
		    
		  Case Is <= 1180591620717411303424.0
		    // Exabyte
		    fileSizeDivisor = 1152921504606846976.0
		    fileSizeSuffix = "EB"
		    
		  Case Else
		    // Zettabyte
		    fileSizeDivisor = 1180591620717411303424.0
		    fileSizeSuffix = "ZB"
		  End Select
		  
		  Return Format(fileSize / fileSizeDivisor, "###0.0") + fileSizeSuffix
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
		Function HasContent(Extends v As String) As Boolean
		  Return (v <> "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValidEmail(Extends value As String) As Boolean
		  Dim rg As New RegEx
		  
		  rg.Options.CaseSensitive = False
		  rg.SearchPattern = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$"
		  
		  Return (rg.Search(value) <> Nil)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Attributes( Deprecated = "M_String.GenerateUUID" )  Function LazyUUID() As String
		  Return EncodeHex(MD5(Format(Microseconds, "000000000000000.000000")+ Str(Rnd))).Lowercase
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Map(Extends s As String, ParamArray mapping() As Pair) As String
		  For i As Integer = 0 To mapping.Ubound
		    Dim p As Pair = mapping(i)
		    s = s.ReplaceAll(p.Left.StringValue, p.Right.StringValue)
		  Next
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Pad(Extends value As String, size As Integer, padWith As String = " ") As String
		  If value.Len > size Then
		    Return value.Left(size)
		  End If
		  
		  Dim diff As Integer = size - value.Len
		  Dim padVal() As String
		  ReDim padVal(diff)
		  
		  Return value + Join(padVal, padWith)
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

	#tag Method, Flags = &h0
		Function Pluralize(count As Integer, singular As string, plural As String = "") As String
		  If count = 1 Then
		    Return singular
		  End If
		  
		  If plural.Len > 0 Then
		    Return plural
		  End If
		  
		  If singular.Right(1) = "y" And kConsonant.Instr(singular.Mid(singular.Len - 1, 1)) > 0 Then
		    Return singular.Left(singular.Len - 1) + "ies"
		  ElseIf singular.Right(1) = "x" Or singular.Right(2) = "ss" Or singular.Right(2) = "ch" Then
		    Return singular + "es"
		  Else
		    Return singular + "s"
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RandomString(length As Integer, startAscii As Integer = 33, endAscii As Integer = 126) As String
		  Static rnd As Random = New Random
		  Dim r() As String
		  
		  Redim r(length)
		  
		  rnd.RandomizeSeed
		  
		  For i As Integer = 0 To length - 1
		    r(i) = ChrB(rnd.InRange(startAscii, endAscii))
		  Next
		  
		  Return Join(r, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReplaceAll(Extends s As String, what() As String, withWhat As String) As String
		  For i As Integer  = 0 To what.Ubound
		    Dim v As String = what(i)
		    s = s.ReplaceAll(v, withWhat)
		  Next
		  
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SingleValue(Extends s As String) As Single
		  Return Val(s.ReplaceAll(",", "").ReplaceAll("$", "").ReplaceAll("%", ""))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SplitLines(content As String) As String()
		  Return ReplaceLineEndings(content, EndOfLine).Split(EndOfLine)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StripMoney(Extends s As String) As String
		  return s.ReplaceAll("$", "").ReplaceAll(",", "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StripTelephoneFormat(Extends value As String) As String
		  Return value.ReplaceAll(Array("-", "(", ")", " "), "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TelephoneFormat(Extends value As String) As String
		  value = value.StripTelephoneFormat
		  
		  If value.Len = 10 Then
		    Return value.Left(3) + "-" + value.Mid(4, 3) + "-" + value.Right(4)
		    
		  ElseIf value.Len > 10 And (value.Mid(11, 1) = "x" Or value.Mid(11, 1) = ",") Then
		    Return value.Left(10).TelephoneFormat + "x" + value.Mid(12)
		  End If
		  
		  Return value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function UnderToCamel(Extends under As String) As String
		  Static cache As New Dictionary
		  
		  If cache.HasKey(under) Then
		    Return cache.Value(under)
		  End If
		  
		  Dim parts() As String = under.Split("_")
		  Dim partsUbound As Integer = parts.Ubound
		  For i As Integer = 0 To partsUbound
		    parts(i) = parts(i).Titlecase
		  Next
		  
		  Dim result As String = Join(parts, "")
		  cache.Value(under) = result
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ZipFormat(Extends value As String) As String
		  If value.Len = 9 Then
		    Return value.Left(5) + "-" + value.Right(4)
		  Else
		    Return value
		  End If
		End Function
	#tag EndMethod


	#tag Constant, Name = kConsonant, Type = String, Dynamic = False, Default = \"bcdfghjklmnpqrstvwxy", Scope = Private
	#tag EndConstant

	#tag Constant, Name = kVowel, Type = String, Dynamic = False, Default = \"aeiou", Scope = Private
	#tag EndConstant


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

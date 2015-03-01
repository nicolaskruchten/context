<?xml version="1.0" encoding="ISO-8859-1"?>


<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="startdate" select="//@startdate" />
<xsl:param name="enddate" select="//@enddate" />
<xsl:param name="barheight" select="//@barheight" />
<xsl:param name="heightgap" select="//@heightgap" />
<xsl:param name="yearwidth" select="//@yearwidth" />
<xsl:param name="vertplace" select="//@vertplace" />
<xsl:param name="pageheight" select="//@pageheight" />


<xsl:template match="/">

	<html>
	<head>
		<title>context</title>
		<link rel="Stylesheet" href="context.css" type="text/css" />
	</head>

	<script language="javascript">

	function drawLine()
	{
		document.getElementById("theline").style.visibility = "visible";
		document.getElementById("thetext").style.visibility = "visible";
		document.getElementById("theline").style.left=document.body.scrollLeft+event.pageX-1;
		document.getElementById("thetext").style.left=document.body.scrollLeft+event.pageX-1;
		document.getElementById("thetext").innerHTML= Math.floor(((document.body.scrollLeft+event.clientX-10) / <xsl:value-of select="$yearwidth" />) + <xsl:value-of select="$startdate" />);

	}

	</script>

	<body onload="javascript:document.body.onclick=drawLine;">

		<div id="theline">
			<xsl:attribute name="style">
				position: absolute; 
				top: 0px; 
				height: <xsl:value-of select="$pageheight" />px; 
				width: 2px; 
				color: white;
				z-index: 2;
				left: 0px; 
				background-color: blue;
				visibility: hidden;
			</xsl:attribute>
		</div>
		<div id="thetext">
			<xsl:attribute name="style">
				position: absolute; 
				top: -1px;
				color: black;
				font-size: 24px;
				font-family: Georgia;
				font-weight: bold;
				z-index: 2;
				left: 0px; 
				background-color: white;
				border: solid black 1px;
				border-left: solid 2px blue;
				visibility: hidden;
				padding-left: 10px;
				padding-right: 10px;
			</xsl:attribute>
		</div>

		<xsl:call-template name="span">
			<xsl:with-param name="currentposition" select="1" />
			<xsl:with-param name="state" select="'1;-10000/'" />
		</xsl:call-template>

		<xsl:call-template name="century">
			<xsl:with-param name="date" select="$enddate - ($enddate mod 50)" />
		</xsl:call-template>

		</body>
	</html>

</xsl:template>



<xsl:template name="span">
	<xsl:param name="currentposition" />
	<xsl:param name="state" />

	<xsl:for-each select="/list/span">
		<xsl:sort select="start" data-type="number" />
		<xsl:if test="$currentposition = position()">

			<!-- display current span -->

			<div>
				<xsl:attribute name="style">
					position: absolute; 
					font-size: 14px;
					font-family: Verdana;
					font-weight: bold;
					padding-left: 10px;
					padding-top: 0px;
					top: <xsl:call-template name="vertpixelposition">
						<xsl:with-param name="start" select="start" />
						<xsl:with-param name="state" select="$state" />
					</xsl:call-template>px; 
					left: <xsl:value-of select="(((start - $startdate) * $yearwidth) + 10)" />px; 
					height: <xsl:value-of select="$barheight" />px; 
					width: <xsl:value-of select="((end - start) * $yearwidth) -1" />px; 
					z-index: 3;
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:value-of select="attribute::type" />
				</xsl:attribute>

				
				<xsl:if test="string-length(info) != 0">
					<xsl:attribute name="onmouseover">
						javascript:document.getElementById("<xsl:value-of select="$currentposition" />").style.visibility = 'visible';
					</xsl:attribute>
				</xsl:if>
					<a style="border: 0px; text-decoration:none;">
						<xsl:attribute name="class">
							<xsl:value-of select="attribute::type" />
						</xsl:attribute>
						<xsl:attribute name="href">
							http://en.wikipedia.org/wiki/Special:Search?search=<xsl:value-of select="name" />
						</xsl:attribute>
						<xsl:value-of select="name" />
					</a>
			</div>
			
			<xsl:if test="string-length(info) != 0">

				<div>
					<xsl:attribute name="style">
						position: absolute; 
						font-size: 14px;
						font-family: Verdana;
						font-weight: bold;
						padding-left: 10px;
						padding-top: 0px;
						top: <xsl:call-template name="vertpixelposition">
							<xsl:with-param name="start" select="start" />
							<xsl:with-param name="state" select="$state" />
						</xsl:call-template>px; 
						left: <xsl:value-of select="(((start - $startdate) * $yearwidth) + 10)" />px; 
						height: <xsl:value-of select="$barheight*3" />px; 
						width: <xsl:value-of select="((end - start) * $yearwidth) -1" />px; 
						visibility: hidden;
						z-index: 3;
					</xsl:attribute>
					<xsl:attribute name="class">
						<xsl:value-of select="attribute::type" />
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="$currentposition" />
					</xsl:attribute>
					<xsl:attribute name="onmouseout">
						javascript:document.getElementById("<xsl:value-of select="$currentposition" />").style.visibility = 'hidden';
					</xsl:attribute>
					<a>
						<xsl:attribute name="href">
							http://en.wikipedia.org/wiki/Special:Search?search=<xsl:value-of select="name" />
						</xsl:attribute>
						<xsl:value-of select="name" />
					</a>
					<br />
					<br />
					<xsl:value-of select="info" />
				</div>

			</xsl:if>

			<!-- recurse if appropriate -->
			
			<xsl:if test="$currentposition != count(/list/span)">
				<xsl:call-template name="span">
					<xsl:with-param name="currentposition" select="$currentposition + 1" />
					<xsl:with-param name="state">
						<xsl:call-template name="updatedstate">
							<xsl:with-param name="newend" select="end" />
							<xsl:with-param name="vertposition">
								<xsl:call-template name="vertposition">
									<xsl:with-param name="start" select="start" />
									<xsl:with-param name="state" select="$state" />
								</xsl:call-template>
							</xsl:with-param>
							<xsl:with-param name="state" select="$state" />
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>


		</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template name="century">
	<xsl:param name="date" />
	<xsl:param name="color">
		<xsl:if test="(($date+10000) mod 100) = 0">
			black
		</xsl:if>
		<xsl:if test="(($date+10000) mod 100) = 50">
			gray
		</xsl:if>
	</xsl:param>
	<xsl:if test="$date &gt;= $startdate">

		<div>
			<xsl:attribute name="style">
				position: absolute; 
				top: 0px; 
				height: <xsl:value-of select="$pageheight" />px; 
				width: 1px; 
				color: white;
				z-index: 1;
				left: <xsl:value-of select="((($date - $startdate) * $yearwidth) + 9)" />px; 
				background-color: <xsl:value-of select="$color" />;
			</xsl:attribute>
		</div>
		
		<div>
			<xsl:attribute name="style">
				position: absolute; 
				top: 0px; 
				font-size: 24px;
				font-family: Georgia;
				font-weight: bold;
				width: 80px;
				z-index: 1;
				left: <xsl:value-of select="((($date - $startdate) * $yearwidth) + 13)" />px; 
				color: <xsl:value-of select="$color" />;
			</xsl:attribute>
			<xsl:value-of select="$date" /><br />
		</div>

		<xsl:call-template name="century">
			<xsl:with-param name="date" select="$date - 50"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="vertpixelposition">
	<xsl:param name="start" />
	<xsl:param name="state" />
	<xsl:param name="vertposition">
		<xsl:call-template name="vertposition">
			<xsl:with-param name="start" select="$start" />
			<xsl:with-param name="state" select="$state" />
		</xsl:call-template>
	</xsl:param>

	<xsl:value-of select="((number($vertposition) * ($barheight+$heightgap)) + 10)" />
</xsl:template>

<xsl:template name="vertposition">
	<xsl:param name="start" />
	<xsl:param name="state" />
	<xsl:param name="position" select="number(substring-before($state, ';'))" />
	<xsl:param name="end" select="number(substring-after(substring-before($state, '/'), ';'))" />

	<xsl:choose>
		<xsl:when test="$start &gt;= $end">
			<xsl:value-of select="$position" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
				<xsl:when test="string-length(substring-after($state, '/')) = 0">
					<xsl:value-of select="$position+1" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="vertposition">
						<xsl:with-param name="start" select="start" />
						<xsl:with-param name="state" select="substring-after($state, '/')" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<xsl:template name="updatedstate">
	<xsl:param name="newend" />
	<xsl:param name="vertposition" />
	<xsl:param name="state" />
	<xsl:param name="position" select="number(substring-before($state, ';'))" />
	<xsl:param name="end" select="number(substring-after(substring-before($state, '/'), ';'))" />
	<xsl:param name="stringtail">
		<xsl:choose>
			<xsl:when test="string-length(substring-after($state, '/')) = 0">
				<xsl:choose>
					<xsl:when test="($position+1) = $vertposition">
						<xsl:value-of select="concat(($vertposition), ';', $newend, '/')" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="''" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="updatedstate">
					<xsl:with-param name="newend" select="$newend" />
					<xsl:with-param name="vertposition" select="$vertposition" />
					<xsl:with-param name="state" select="substring-after($state, '/')" />
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:choose>
		<xsl:when test="$position = $vertposition">
			<xsl:value-of select="concat($position, ';', $newend, '/', $stringtail)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="concat($position, ';', $end, '/', $stringtail)" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
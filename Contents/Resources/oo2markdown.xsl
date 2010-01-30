<?xml version='1.0' encoding='utf-8'?>

<!-- OmniOutliner-to-Markdown converter by Fletcher Penney
	Version 1.1.1
-->

<!-- # Copyright (C) 2005  Fletcher T. Penney <fletcher@freeshell.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the
#    Free Software Foundation, Inc.
#    59 Temple Place, Suite 330
#    Boston, MA 02111-1307 USA -->

<!-- To Do:
	Handle checkboxes?  Parse only checked/indeterminate?  Have a meta-option?
	Could check to see if any are checked, if so then parse checked/indet?
-->

<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oo="http://www.omnigroup.com/namespace/OmniOutliner/v3"
	xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="oo"
	version="1.0">

	<xsl:output method='text' encoding='utf-8'/>

	<xsl:strip-space elements="*" />

	<xsl:variable name="newline">
<xsl:text>
</xsl:text>
	</xsl:variable>

	<xsl:variable name="tab">
<xsl:text>	</xsl:text>
	</xsl:variable>

	<xsl:variable name="ignorecolumn">
<xsl:text>my notes</xsl:text>
	</xsl:variable>

	<xsl:variable name="non-note-columns" select="oo:outline/oo:columns/oo:column[not(@is-note-column) or @is-note-column != 'yes']" />

	<!-- Go thru all the columns and determine which one is the topic column -->
	<xsl:variable name="outline-column-position">
		<xsl:for-each select="$non-note-columns">
			<xsl:if test="@is-outline-column = 'yes'">
				<xsl:value-of select="position()"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:apply-templates select="oo:outline"/>
	</xsl:template>

	<xsl:template match="oo:outline">
		<xsl:apply-templates select="oo:root"/>
	</xsl:template>

	<xsl:template match="oo:root">
		<xsl:apply-templates select="/oo:outline/oo:root/oo:item[last()]" mode="meta"/>
		<xsl:apply-templates select="oo:item">
			<xsl:with-param name="header">
				<xsl:text>#</xsl:text>
				<xsl:apply-templates select="/oo:outline/oo:root/oo:item[last()]" mode="headerlevel"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="oo:item" mode="meta">
		<xsl:variable name="title" select="normalize-space(oo:values/oo:text/oo:p)"/>
		<xsl:if test="translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'metadata'">
			<xsl:apply-templates select="oo:children" mode="metadata"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="oo:item" mode="metadata">
		<xsl:value-of select="normalize-space(oo:values/oo:text/oo:p)"/>
		<xsl:text>:</xsl:text>
		<xsl:apply-templates select="oo:note"/>
		<xsl:variable name="val" select="normalize-space(oo:note)"/>
		<xsl:if test="$val = ''">
			<xsl:text>
</xsl:text>
		</xsl:if>
		<xsl:apply-templates select="oo:children" mode="metadata"/>
	</xsl:template>

	<xsl:template match="/oo:outline/oo:root/oo:item[last()]" mode="headerlevel">
		<xsl:variable name="title" select="normalize-space(oo:values/oo:text/oo:p)"/>
		<xsl:if test="translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'metadata'">
			<xsl:apply-templates select="oo:children" mode="headerlevel"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="oo:item" mode="headerlevel">
		<xsl:variable name="title" select="normalize-space(oo:values/oo:text/oo:p)"/>
		<xsl:if test="translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'headerlevel'">
			<xsl:value-of select="normalize-space(oo:note/oo:text/oo:p)"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="/oo:outline/oo:root/oo:item[count(following-sibling) = 0]">
		<!-- The count bit is a hack, since the version of xsltproc shipping
			with Mac OS X is currently broken, and doesn't properly 
			support last() -->
		<xsl:param name="header"/>
		<xsl:variable name="title" select="normalize-space(oo:values/oo:text/oo:p)"/>
		<xsl:if test="not(translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = 'metadata')">
			<xsl:if test="not(translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
				'abcdefghijklmnopqrstuvwxyz') = $ignorecolumn)">
				<xsl:value-of select="$newline"/>
				<xsl:value-of select="$newline"/>
				<xsl:value-of select="concat($header,' ')"/>
				<xsl:apply-templates select="oo:values/oo:text[position() = $outline-column-position]/oo:p"/>
				<xsl:value-of select="concat(' ',$header)"/>
				<xsl:value-of select="$newline"/>
				<xsl:value-of select="$newline"/>
				<xsl:apply-templates select="oo:note"/>
				<xsl:apply-templates select="oo:children">
					<xsl:with-param name="header" select="concat($header,'#')"/>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="oo:item">
		<xsl:param name="header"/>
		<xsl:variable name="title" select="normalize-space(oo:values/oo:text[position() = $outline-column-position]/oo:p)"/>
		<xsl:if test="not(translate($title,'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz') = $ignorecolumn)">
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="concat($header,' ')"/>
			<xsl:apply-templates select="oo:values/oo:text[position() = $outline-column-position]/oo:p"/>
			<xsl:value-of select="concat(' ',$header)"/>
			<xsl:value-of select="$newline"/>
			<xsl:value-of select="$newline"/>
			<xsl:apply-templates select="oo:note"/>
			<xsl:apply-templates select="oo:children">
				<xsl:with-param name="header" select="concat($header,'#')"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>
		
	<xsl:template match="oo:children">
		<xsl:param name="header"/>
		<xsl:apply-templates select="oo:item">
			<xsl:with-param name="header" select="$header"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="oo:note" mode="metadata">
		<xsl:apply-templates mode="metadata"/>
	</xsl:template>

	<xsl:template match="oo:note">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="oo:note/oo:text/oo:p">
		<xsl:apply-templates/>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	<xsl:template match="oo:cell">
		<xsl:text>![</xsl:text>
		<xsl:value-of select="@refid"/>
		<xsl:value-of select="@name"/>
		<xsl:value-of select="@href"/>
		<xsl:text>](</xsl:text>
		<xsl:text>)</xsl:text>
		<xsl:value-of select="$newline"/>
	</xsl:template>

	
	<xsl:template match="oo:note/oo:text/oo:p/oo:run/oo:style">
	</xsl:template>

	<xsl:template match="oo:note/oo:text/oo:p" mode="metadata">
		<xsl:apply-templates/>
	</xsl:template>
	

	<!-- replace-substring routine by Doug Tidwell - XSLT, O'Reilly Media -->
	<xsl:template name="replace-substring">
		<xsl:param name="original" />
		<xsl:param name="substring" />
		<xsl:param name="replacement" select="''"/>
		<xsl:variable name="first">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)" >
					<xsl:value-of select="substring-before($original, $substring)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$original"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="middle">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)" >
					<xsl:value-of select="$replacement"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="last">
			<xsl:choose>
				<xsl:when test="contains($original, $substring)">
					<xsl:choose>
						<xsl:when test="contains(substring-after($original, $substring), $substring)">
							<xsl:call-template name="replace-substring">
								<xsl:with-param name="original">
									<xsl:value-of select="substring-after($original, $substring)" />
								</xsl:with-param>
								<xsl:with-param name="substring">
									<xsl:value-of select="$substring" />
								</xsl:with-param>
								<xsl:with-param name="replacement">
									<xsl:value-of select="$replacement" />
								</xsl:with-param>
							</xsl:call-template>
						</xsl:when>	
						<xsl:otherwise>
							<xsl:value-of select="substring-after($original, $substring)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text></xsl:text>
				</xsl:otherwise>		
			</xsl:choose>				
		</xsl:variable>		
		<xsl:value-of select="concat($first, $middle, $last)"/>
	</xsl:template>

</xsl:stylesheet>
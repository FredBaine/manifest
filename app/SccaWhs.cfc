r<cfcomponent extends="JSONUtil">

<cffunction name="getWarehouses" returntype="any" access="remote" returnformat="plain">

	<cftry>
    <cfquery name="qryWhs" datasource="WEBDATA">
		SELECT WHS, NAME
	 	FROM CPWHSMST
	 	WHERE ISCLOSED <>  'Y'
	</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryWhs)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="getWarehouse" returntype="any" access="remote" returnformat="plain">
    <cfargument name="whs" 		default="">

	<cftry>
    <cfquery name="qryWhs" datasource="WEBDATA">
		SELECT *
	 	FROM WHSMST7
	 	WHERE
				WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
	</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryWhs)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="getOrders" returntype="any" access="remote" returnformat="plain">

	<cfargument name="whs" required="yes">

	<cftry>
    <cfquery name="qryOrders" datasource="WEBDATA">
		SELECT WHS, ORDERNO, TRIM(MARK) AS MARK
		, CASE WHEN DUEDATE IS NULL THEN 'TBA' ELSE CHAR(DUEDATE) END AS DUEDATE
		, BALES
		, CASE WHEN SHIPDATE IS NOT NULL THEN 'Shipped' ELSE
			CASE WHEN RDYDATE IS NOT NULL THEN 'Ready' ELSE
				CASE WHEN MANIDATE IS NOT NULL THEN 'Manifested' ELSE
					CASE WHEN ORDERNO <> '00000' THEN 'Ordered' END
				END
			END
		  END AS STATUS
		, BUYER
		, SHIPPER
		, DEST
	 	FROM VCPORD
	 	WHERE 1 = 1
	 	     AND SHIPDATE IS NULL
	 	     AND RDYDATE IS NULL
	 	     AND DUEDATE IS NOT NULL
	 	     AND BALES > 0
	 	     AND WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
	 	ORDER BY CASE WHEN DUEDATE IS NULL THEN '12/31/27' ELSE DUEDATE END
	</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryOrders)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="getMark" returntype="any" access="remote" returnformat="plain">
	<cfargument name="whs" required="yes">
	<cfargument name="mark" required="yes">
	<cftry>
    <cfquery name="qryMark" datasource="WEBDATA">
		SELECT WHS, ORDERNO, MARK
		, CASE WHEN DUEDATE IS NULL THEN 'TBA' ELSE CHAR(DUEDATE) END AS DUEDATE
		, BALES
		, CASE WHEN SHIPDATE IS NOT NULL THEN 'Shipped' ELSE
			CASE WHEN RDYDATE IS NOT NULL THEN 'Ready' ELSE
				CASE WHEN MANIDATE IS NOT NULL THEN 'Manifested' ELSE
					CASE WHEN ORDERNO <> '00000' THEN 'Ordered' END
				END
			END
		  END AS STATUS
		, BUYER
		, SHIPPER
		, DEST
	 	FROM VCPORD
	 	WHERE  WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
	 	     AND MARK = <cfqueryparam value = '#ucase(arguments.MARK)#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="8">
	 	     AND SHIPDATE IS NULL
	 	     AND BALES > 0
	</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryMark)>
	<cfcontent reset="yes">
	<cfreturn serializeToJSON(returnArray[1], true, true)>

</cffunction>

<cffunction name="signInOrder" returntype="any" access="remote" returnformat="plain">
	<cfargument name="whs" required="yes">
	<cfargument name="orderno" required="yes">

	<!--- Insert Row into Daily Orders Shipped Table --->
	<cftry>
    <cfquery name="qryOrders" datasource="WEBDATA">
		SELECT WHS, ORDERNO, MARK
		, CASE WHEN DUEDATE IS NULL THEN 'TBA' ELSE CHAR(DUEDATE) END AS DUEDATE
		, BALES
		, CASE WHEN SHIPDATE IS NOT NULL THEN 'Shipped' ELSE
			CASE WHEN RDYDATE IS NOT NULL THEN 'Ready' ELSE
				CASE WHEN MANIDATE IS NOT NULL THEN 'Manifested' ELSE
					CASE WHEN ORDERNO <> '00000' THEN 'Ordered' END
				END
			END
		  END AS STATUS
		, BUYER
		, SHIPPER
		, DEST
	 	FROM VCPORD
	 	WHERE 1 = 1
	 	     AND SHIPDATE IS NULL
	 	     AND RDYDATE IS NOT NULL
	 	     AND BALES > 0
	 	     AND WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
	 	ORDER BY CASE WHEN DUEDATE IS NULL THEN '12/31/27' ELSE DUEDATE END
	</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryOrders)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="LoadingNotice" access="remote">
<!--- <cfheader name="Content-Disposition" value="attachment; filename=TruckLoadingNotice.pdf"> --->
<cfheader name="Content-Type" value="application/pdf; filename=foo.pdf">
<cfheader name="Content-Disposition" value="filename=foo.pdf">
<cfdocument format="pdf"
			marginBottom= ".25"
			marginTop	= ".9"
			marginRight	= ".25"
			marginLeft	= ".25"
			orientation = "portrait"
			pageType = "letter"
			>
<html>
<head><title>EB668</title></head>
<body>
<div> 01/14/15          STAPLCOTN WAREHOUSE TRUCK LOADING NOTICE          16:22:18</div>
<div>                          476512 Greer                                         </div>
 <div>&nbsp;</div>
<div>  Order: 62685       Mark: EB668     Bales: 88    Location:  </div>
 <div>&nbsp;</div>
<div>  Buyer: STAPLE COTTON COOP. ASSN. </div>
<div>&nbsp;</div>
<div>  Container: 12345678901</div>
<div>  Seal 1: 1234567</div>
<div>  Seal 2: 1234567</div>
<div>&nbsp;</div>
<table>
	<thead><tr><td>Instructions</td></tr></thead>
	<tbody>
		<tr><td>COVER SAMPLE HOLES BALE GRADE "A"</td></tr>
		<tr><td>EXPORT</td></tr>
		<tr><td>ALL BALES MUST BE MARKED</td></tr>
		<tr><td>PLEASE REFERENCE BUYER INVOICE/SO NUMBER WHEN BILLING</td></tr>
		<tr><td>NO BROKEN BANDS - WILL REJECT</td></tr>
		<tr><td>PHYTOSANITARY INSPECTION REQUIRED</td></tr>
	</tbody>
</table>

<div>
Truck Tag Number:    __________________________________________
</div>
<div>
Trailer Number:      __________________________________________
</div>
<div>
Driver's Signature:  __________________________________________
</div>
</body>
</html>
</cfdocument>

</cffunction>

<cffunction name="getShedSummary" returntype="any" access="remote" returnformat="plain">

    <cfargument name="whs" 	default="">

	<cftry>
    <cfquery name="qryShedSummary" datasource="WEBDATA">
		SELECT LEFT(LOCATION1,2) AS SHED
			, SUM(CASE WHEN BRKOUTDATE IS NOT NULL THEN 1 ELSE 0 END) AS READY
			, SUM(CASE WHEN BRKOUTDATE IS NULL AND MANIFDATE IS NOT NULL THEN 1 ELSE 0 END) AS MANIFESTED
			, SUM(CASE WHEN BRKOUTDATE IS NULL AND MANIFDATE IS NULL AND ORDERNO <> '00000' THEN 1 ELSE 0 END) AS ORDERED
			, SUM(CASE WHEN BRKOUTDATE IS NULL AND MANIFDATE IS NULL AND ORDERNO =  '00000' THEN 1 ELSE 0 END) AS OPEN
		FROM WEBDATA.VCPRCT
			 	WHERE 1 = 1
			 	     AND CONTRACT <> '0895011'
			 	     AND SHIPDATE IS NULL
			 	     AND WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
		GROUP BY LEFT(LOCATION1,2)
		ORDER BY LEFT(LOCATION1,2)
	</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryShedSummary)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="getCalendar" returntype="any" access="remote" returnformat="plain">

	<cfargument name="StartDate" 				type="string" required="false" default='#dateformat(now(), "mm/dd/yy")#'>
	<cfargument name="Whs" 						type="string" required="false" default='476512'>

	<cfset EndDay 		= DaysInMonth(arguments.StartDate)>
	<cfset StartMonth	= dateformat(arguments.StartDate, "mm")>
	<cfset StartYear 		= dateformat(arguments.StartDate, "yy")>
	<cfset BeginDate		= dateformat('#StartMonth#/01/#StartYear#')>
	<cfset EndDate		= dateformat('#StartMonth#/#EndDay#/#StartYear#')>

<!--- Creates one row per day between first and last day of the week of the given date --->
	<cftry>
	<cfquery name="qryCalendar" datasource="WEBDATA">
			WITH RANGE(start, end) as (
				SELECT
					DATE('#dateformat(BeginDate, "mm/dd/yy")#'),
					DATE('#dateformat(EndDate, "mm/dd/yy")#')
				FROM SYSDUMMY1
			)
			, WKDATES (WORKDATE)  AS (
				SELECT START FROM RANGE
				 UNION ALL
			 	SELECT WORKDATE + 1 DAYS
			 	 FROM WKDATES
			 	 WHERE WORKDATE < (SELECT END FROM RANGE)
			)
			SELECT
				  CHAR(WORKDATE) AS WORKDATE
				, CASE WHEN H.H_DATE IS NOT NULL THEN 'true' ELSE 'false' END AS isHoliday
				, COALESCE((SELECT SUM(SHIPLIMIT)
					FROM CPWHSMST W
					WHERE 1=1
					 <cfif arguments.Whs NEQ '999999'>
						AND W.WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
					</cfif>
					 ), 0) AS SHIPLIMIT
				, COALESCE((SELECT SUM(CASE WHEN O.RECONTYPE = 'T' THEN 90 ELSE BALES END)
					 FROM VCPORD O
					 WHERE O.DUEDATE = WD.WORKDATE
					 <cfif arguments.Whs NEQ '999999'>
						AND O.WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
					</cfif>
					  AND O.SHIPDATE IS NULL
					  AND O.MARK NOT IN ('DEBIT', 'CREDIT')), 0) AS OUTBOUND
				, COALESCE((SELECT SUM(BALES)
					 FROM VCPORD O
					 WHERE O.DUEDATE = WD.WORKDATE
					 <cfif arguments.Whs NEQ '999999'>
						AND O.WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
					</cfif>
					  AND O.RDYDATE <= WD.WORKDATE
					  AND O.SHIPDATE IS NULL
					  AND O.MARK NOT IN ('DEBIT', 'CREDIT')), 0) AS READY
				, COALESCE((SELECT SUM(BALES)
				      FROM SHIPDATES INB
				      JOIN CPWHSMST W ON W.WHS = INB.WAREHOUSE AND W.ISCLOSED = 'N'
				      WHERE INB.WHSDATE = WD.WORKDATE
				          AND INB.INOUT = 'IN'
				          AND (SELECT MAX(RCVDATE) FROM VCPRECON R WHERE INB.WAREHOUSE = R.WHS AND INB.SHIPMARK = R.FROMMARK) IS NULL
					 <cfif arguments.Whs NEQ '999999'>
						AND INB.WAREHOUSE = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
					</cfif>
				      	AND INB.ISWHSDAYFAKE <> 1), 0) AS INBOUND
			FROM WKDATES WD
			LEFT JOIN HOLIDAYS H ON WD.WORKDATE = H.H_DATE
			ORDER BY WORKDATE
	</cfquery>
	<cfcatch>
		<cfthrow message="qryWeekDayTotals: #cfcatch.detail# #cfcatch.message#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryCalendar)>
	<cfreturn serializeToJSON(returnArray, true, true)>


</cffunction>

<cffunction name="getBales" returntype="any" access="remote" returnformat="plain">

	<cfargument name="whs" required="yes">
	<cfargument name="orders" required="yes">

	<!--- get All blocks that have bales on these orders --->
	<cftry>
	    <cfquery name="qryBlocks" datasource="WEBDATA" result="results">
			SELECT LEFT(C.LOCATION1, 4) as BLOCK
		 	FROM VCPRCT C
		 	JOIN CPBLOKLOC B ON C.WHS = B.WHS AND LEFT(C.LOCATION1,2) = B.SHED
		 	WHERE C.WHS 			= '#arguments.whs#'
		 	    AND C.SHIPDATE IS NULL
		 	    AND C.BRKOUTDATE IS NULL
		 	    AND C.ORDERNO IN #preserveSingleQuotes(arguments.orders)#
		 	    AND B.BLOCK = 'Y'
		 	GROUP BY C.LOCATION1
		</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message# #cfcatch.sql#">
	</cfcatch>
	</cftry>

	<cfset blockList = "('#valuelist(qryBlocks.BLOCK, "','")#')">
	<cfset today = dateFormat(now(), "mm/dd/yy")>

	<!--- get All bales that are in the blocks if on order and not TBA --->
	<cftry>
	    <cfquery name="qryBales" datasource="WEBDATA" result="results">
			SELECT C.WHS, C.ORDERNO, C.GIN || C.GINBALE as PBI, C.RCT, C.BAGGING, C.LOCATION1, C.LOCATION2
			, LEFT(C.LOCATION1,4) AS BLOCK
			, O.MARK
			, CHAR(O.DUEDATE) AS DUEDATE
			, CASE WHEN C.ORDERNO IN #preserveSingleQuotes(arguments.orders)# THEN 1 ELSE 0 END AS isPrimary
			, DAYS(O.DUEDATE) - DAYS('#today#') AS daysOut
		 	FROM VCPRCT C
		 	LEFT JOIN VCPORD O ON C.WHS = O.WHS AND C.ORDERNO = O.ORDERNO
		 	WHERE C.WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
		 	    AND C.SHIPDATE IS NULL
		 	    AND C.BRKOUTDATE IS NULL
		 	    AND O.DUEDATE IS NOT NULL
		 	    AND ( LEFT(C.LOCATION1,4) IN #preserveSingleQuotes(blockList)# OR
		 	    		 	C.ORDERNO IN #preserveSingleQuotes(arguments.orders)#)
		 	ORDER BY LEFT(C.LOCATION1,4),
		 		CASE WHEN C.ORDERNO IN #preserveSingleQuotes(arguments.orders)# THEN 1 ELSE 2 END,
		 		O.DUEDATE
		</cfquery>
	<cfcatch>
		<cfthrow message="#cfcatch.detail# #cfcatch.message# #cfcatch.sql#">
	</cfcatch>
	</cftry>

	<cfset returnArray = queryToArray(qryBales)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="uploadLocation" returntype="any" access="remote" returnformat="plain">

	<cfset var returnStruct = structNew()>
 	<cftry>
		<cfquery name="qryAddLocation" datasource="WEBDATA">
			INSERT INTO CPLOCATION
			(GIN, GINBALE, LOCATION, LOCDATE, SOURCE, WHS)
			VALUES (
			  '#UCASE(LEFT(trim(arguments.PBI),5))#'
			  ,'#MID(trim(arguments.PBI),6,7)#'
			 , '#trim(arguments.LOCATION)#'
			 , '#dateformat(now(), "yymmdd")#'
			 , 'W'
			 , '#arguments.WHS#'
			 )
		</cfquery>

		<cfcatch>
			<cfif cfcatch.nativeErrorCode EQ -803>
				<cftry>
					<cfquery name="qryAddLocation" datasource="WEBDATA">
						UPDATE CPLOCATION
						 SET LOCATION = '#trim(arguments.LOCATION)#'
						 WHERE WHS = '#arguments.WHS#'
						      AND GIN = '#UCASE(LEFT(trim(arguments.PBI),5))#'
						      AND GINBALE = '#MID(trim(arguments.PBI),6,7)#'
					</cfquery>
					<cfcatch>
						<cfthrow message="#cfcatch.detail# #cfcatch.message#">
					</cfcatch>
				</cftry>
			<cfelse>
				<cfthrow message="#cfcatch.detail# #cfcatch.message#">
			</cfif>
		</cfcatch>

		<cfcatch>
			<cfthrow message="#cfcatch.detail# #cfcatch.message#">
		</cfcatch>
	</cftry>

	<cfset returnStruct['IDNO'] = "#arguments.PBI#">
	<cfreturn serializeToJSON(returnStruct, true, true)>

</cffunction>

<cffunction name="buildManifest" returntype="any" access="remote" returnformat="plain">
	<cfargument name="whs" required="yes">
	<cfargument name="orders" required="yes">
	<cfargument name="daysOut" required="no" default="14">

	<cfset today = dateFormat(now(), "mm/dd/yy")>

	<cfquery name="qryNextManifestNo" datasource="WEBDATA">
		SELECT MAX(MANI_NUM) as LastNum
		FROM WEBDATA.CPMANIFEST
	</cfquery>

	<cfif qryNextManifestNo.LastNum EQ ''>
		<cfset nextManiNum = 1>
	<cfelse>
		<cfset nextManiNum = qryNextManifestNo.LastNum + 1>
	</cfif>

	<cfquery name="buildManifest" datasource="WEBDATA">
		INSERT INTO WEBDATA.CPMANIFEST (
		 WHS, MANI_NUM, PBI, LOCATION1, LOCATION2, BLOCK, ORDERNO, MARK, DUE_DATE, PRIORITY, ISPRIMARY
		)
		WITH BLOCKS AS (
					SELECT LEFT(C.LOCATION1, 4) as BLOCK
				 	FROM PRODDATA.VCPRCT C
				 	JOIN PRODDATA.CPBLOKLOC B ON C.WHS = B.WHS AND LEFT(C.LOCATION1,2) = B.SHED
				 	WHERE C.WHS 			= <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
				 	    AND C.SHIPDATE IS NULL
				 	    AND C.BRKOUTDATE IS NULL
				 	    AND C.ORDERNO IN #preserveSingleQuotes(arguments.orders)#
				 	    AND B.BLOCK = 'Y'
				 	GROUP BY LEFT(C.LOCATION1, 4)
		)
		(
		SELECT C.WHS
					, #nextManiNum#
					, C.GIN || C.GINBALE as PBI
					, C.LOCATION1
					, C.LOCATION2
					, LEFT(C.LOCATION1,4) AS BLOCK
					, O.ORDERNO
					, O.MARK
					, O.DUEDATE
					, CASE WHEN C.ORDERNO IN #preserveSingleQuotes(arguments.orders)# THEN 1 ELSE
			                 CASE WHEN DAYS(O.DUEDATE) - DAYS('#today#') < #arguments.daysOut# THEN 2 ELSE 9 END END
					, CASE WHEN C.ORDERNO IN #preserveSingleQuotes(arguments.orders)# THEN 'Y' ELSE 'N' END AS ISPRIMARY
				 	FROM PRODDATA.VCPRCT C
				 	LEFT JOIN PRODDATA.VCPORD O ON C.WHS = O.WHS AND C.ORDERNO = O.ORDERNO
				 	LEFT JOIN BLOCKS B ON B.BLOCK = LEFT(C.LOCATION1,4)
				 	WHERE C.WHS =<cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
				 	    AND C.SHIPDATE IS NULL
				 	    AND C.BRKOUTDATE IS NULL
				 	    AND O.DUEDATE IS NOT NULL
				 	    AND ( B.BLOCK IS NOT NULL OR C.ORDERNO IN #preserveSingleQuotes(arguments.orders)#)
		)
	</cfquery>

</cffunction>

<cffunction name="deleteManifest" returntype="any" access="remote" returnformat="plain">
	<cfargument name="whs" required="yes">
	<cfargument name="mani_num" required="yes">

	<cfquery name="qryDeleteManifest" datasource="WEBDATA">
		DELETE
		FROM WEBDATA.CPMANIFEST
		WHERE WHS = <cfqueryparam value = '#arguments.whs#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
		  AND MANI_NUM = <cfqueryparam value = '#arguments.mani_num#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
	</cfquery>

</cffunction>

<cffunction name="getManifestsOnFile" returntype="any" access="remote" returnformat="plain">
	<cfargument name="whs" required="yes">

	<cfquery name="qryManifests" datasource="WEBDATA">
		WITH T1 AS (
			SELECT WHS, MANI_NUM, MIN(TSTMP) AS TM_STAMP
				, SUM(CASE WHEN PRIORITY = '1' THEN 1 ELSE 0 END) AS PRIMARY_BALES
				, SUM(CASE WHEN PRIORITY <> '1' THEN 1 ELSE 0 END) AS SECONDARY_BALES
				, COUNT(*) AS TOTAL_BALES
			FROM WEBDATA.CPMANIFEST
			WHERE WHS = <cfqueryparam value = '#arguments.WHS#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
			GROUP BY WHS, MANI_NUM
		)
		SELECT WHS, MANI_NUM, TM_STAMP, PRIMARY_BALES, SECONDARY_BALES, TOTAL_BALES
		, (SELECT COUNT(DISTINCT BLOCK) 
			FROM WEBDATA.CPMANIFEST B 
			WHERE T1.WHS = B.WHS AND T1.MANI_NUM = B.MANI_NUM
		  ) AS NUM_BLOCKS
		, (SELECT COUNT(DISTINCT ORDERNO) 
			FROM WEBDATA.CPMANIFEST B 
			WHERE T1.WHS = B.WHS AND T1.MANI_NUM = B.MANI_NUM AND ISPRIMARY = 'Y'
		  ) AS PRIMARY_ORDERS
		, (SELECT COUNT(*)
			FROM WEBDATA.CPMANIFEST B 
			WHERE T1.WHS = B.WHS AND T1.MANI_NUM = B.MANI_NUM AND ISPRIMARY = 'Y' AND ISPULLED = 'Y'
		  ) AS BALES_PULLED
		, (SELECT COUNT(*)
			FROM WEBDATA.CPMANIFEST B 
			WHERE T1.WHS = B.WHS AND T1.MANI_NUM = B.MANI_NUM AND ISPRIMARY <> 'Y' AND ISFRONT = 'Y'
		  ) AS BALES_FRONTED
		FROM T1
		ORDER BY MANI_NUM DESC
	</cfquery>

	<cfset returnArray = queryToArray(qryManifests)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

<cffunction name="getManifestBales" returntype="any" access="remote" returnformat="plain">
	<cfargument name="mani_num" required="yes">

	<cfquery name="qryManiBales" datasource="WEBDATA">
		SELECT WHS
		, MANI_NUM
		, PBI
		, LOCATION1
		, LOCATION2
		, BLOCK
		, RIGHT(LOCATION1,1) AS DEPTH
		, MARK
		, CHAR(DUE_DATE) AS DUE_DATE
		, PRIORITY
		, ISPULLED
		, ISFRONT
		, ISPRIMARY
		, CASE WHEN PRIORITY = 1 THEN 'PRIMARY'
		       WHEN PRIORITY = 2 THEN 'SECONDARY'
		       ELSE 'NOBIGGIE'
		    END AS IMPORTANCE 
		FROM CPMANIFEST
		WHERE MANI_NUM = <cfqueryparam value = '#arguments.mani_num#' CFSQLTYPE = 'CF_SQL_CHAR' maxlength="6">
		ORDER BY BLOCK, PRIORITY
	</cfquery>

	<cfset returnArray = queryToArray(qryManiBales)>
	<cfreturn serializeToJSON(returnArray, true, true)>

</cffunction>

</cfcomponent>
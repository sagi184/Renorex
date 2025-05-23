<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="utf-8" media-type="text/html" doctype-public="-//W3C//DTD HTML 4.0//EN" />
    <xsl:variable name="cellsPerRow" select="3" />
    <xsl:variable name="maxItems" select="1000" />

    <xsl:param name="testcaserid" />
    <xsl:param name="loadAll" />
    <xsl:param name="startMode" />

    <!-- Only for dynamic content loading -->
    <xsl:template match="*[@dynamic-load=1]">
        <xsl:if test="$startMode = 'TestCaseDetail'">
            <xsl:apply-templates select="/descendant-or-self::activity[@rid = $testcaserid]/activity | /descendant-or-self::activity[@rid = $testcaserid]/item" mode="nest">
                <xsl:with-param name="itemCount" select="$maxItems" />
                <xsl:with-param name="isSibling">true</xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
        <xsl:if test="$startMode = 'TestModuleDetail'">
            <xsl:apply-templates select="./descendant-or-self::activity[@rid = $testcaserid]/item" mode="nest">
                <xsl:with-param name="itemCount" select="$maxItems" />
                <xsl:with-param name="isSibling">false</xsl:with-param>
            </xsl:apply-templates>
        </xsl:if>
    </xsl:template>

    <!-- Report Root Content -->
    <xsl:template match="/report/*">

        <xsl:if test="$startMode = ''">
            <div id="header-top">
                <h1 id="logo">
                    <span title="Ranorex">
                        <em>Ranorex Report</em>
                    </span>
                </h1>
                <div id="small-nav"></div>
            </div>
            <div id="page">
                <div id="container">
                    <div id="Content">
                        <xsl:choose>
                            <!-- Testsuit Template -->
                            <xsl:when test="./activity[@type='test-suite' or @type='test-case' or @type='smart-folder' or @type='iteration-container' or @type='entry-container']">
                                <h1>
                                    <xsl:choose>
                                        <xsl:when test="./activity/@headertext">
                                            <xsl:value-of select="./activity/@headertext" />
                                        </xsl:when>
                                        <xsl:otherwise>Report for selected test item</xsl:otherwise>
                                    </xsl:choose>
                                </h1>
                                <td>
                                    <xsl:value-of select="./activity/@reportdescription" />
                                </td>
                                <p>
                                    <xsl:choose>
                                        <xsl:when test="../@progress != '' ">
                                            <div class="progress">
                                                <img alt="progress" width="16" height="11" src="data:image/gif;base64,R0lGODlhEAALAPQAAPPz8wAAANDQ0MbGxt/f3wUFBQAAACwsLHx8fFtbW7GxsSAgIEZGRoSEhF9fX7W1tSQkJAMDA0pKStzc3M7Ozunp6TU1NdLS0ufn566urpmZmcHBwePj4wAAAAAAAAAAACH+GkNyZWF0ZWQgd2l0aCBhamF4bG9hZC5pbmZvACH5BAALAAAAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAALAAAFLSAgjmRpnqSgCuLKAq5AEIM4zDVw03ve27ifDgfkEYe04kDIDC5zrtYKRa2WQgAh+QQACwABACwAAAAAEAALAAAFJGBhGAVgnqhpHIeRvsDawqns0qeN5+y967tYLyicBYE7EYkYAgAh+QQACwACACwAAAAAEAALAAAFNiAgjothLOOIJAkiGgxjpGKiKMkbz7SN6zIawJcDwIK9W/HISxGBzdHTuBNOmcJVCyoUlk7CEAAh+QQACwADACwAAAAAEAALAAAFNSAgjqQIRRFUAo3jNGIkSdHqPI8Tz3V55zuaDacDyIQ+YrBH+hWPzJFzOQQaeavWi7oqnVIhACH5BAALAAQALAAAAAAQAAsAAAUyICCOZGme1rJY5kRRk7hI0mJSVUXJtF3iOl7tltsBZsNfUegjAY3I5sgFY55KqdX1GgIAIfkEAAsABQAsAAAAABAACwAABTcgII5kaZ4kcV2EqLJipmnZhWGXaOOitm2aXQ4g7P2Ct2ER4AMul00kj5g0Al8tADY2y6C+4FIIACH5BAALAAYALAAAAAAQAAsAAAUvICCOZGme5ERRk6iy7qpyHCVStA3gNa/7txxwlwv2isSacYUc+l4tADQGQ1mvpBAAIfkEAAsABwAsAAAAABAACwAABS8gII5kaZ7kRFGTqLLuqnIcJVK0DeA1r/u3HHCXC/aKxJpxhRz6Xi0ANAZDWa+kEAA7AAAAAAAAAAAA" />
                                                <span style="padding-left:5px;">Test in progress</span>
                                            </div>
                                        </xsl:when>
                                    </xsl:choose>
                                </p>
                                <p>
                                    <xsl:choose>
                                        <xsl:when test="./activity[@type='test-suite']">
                                            <div class="literalHtml">
                                                <xsl:value-of select="./activity/detail" disable-output-escaping="yes" />
                                            </div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="literalHtml">
                                                <xsl:value-of select="./detail" disable-output-escaping="yes" />
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="./activity/@runlabel" />
                                    <xsl:if test="../activity/@sutversion">
                                        <br />
                                        <xsl:value-of select="../activity/@sutversion" />
                                    </xsl:if>
                                </p>

                                <br />

                                <!-- EXECUTION INFORMATION -->
                                <xsl:call-template name="executionInformation" />

                                <xsl:variable name="itemCount">
                                    <xsl:value-of select="count(.//item)" />
                                </xsl:variable>

                                <div>
                                    <!-- BUTTONS -->
                                    <div>
                                        <xsl:choose>
                                            <xsl:when test="$itemCount &lt; $maxItems">
                                                <xsl:if test="not(@testentry-activity-type = 'testmodule')">
                                                    <input type="button" onclick="expandTestcases()" class="exButton" value="Expand test containers" />
                                                </xsl:if>
                                                <input type="button" onclick="expandDetails()" class="exButton" value="Expand details" />
                                                <input type="button" onclick="collapseAll()" class="exButton" value="Collapse all" />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:if test="not(@testentry-activity-type = 'testmodule')">
                                                    <input type="button" onclick="expandTestcases()" class="exButton" value="Expand test containers" />
                                                </xsl:if>
                                                <input type="button" onclick="expandDetails()" class="exButton" value="Expand details" />
                                                <input type="button" onclick="collapseAll()" class="exButton" value="Collapse all" />
                                                <em style="color: #888; font-size: 12px;">Expanding/collapsing the details could take a longer time due to the large number of items.</em>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                    <!-- PIECHART -->
                                    <xsl:if test="not(@testentry-activity-type = 'testmodule')">
                                        <h3 id="testCasesHeader">Test case result summary</h3>
                                        <div id="testCasesPie">
                                            <xsl:attribute name="totalsuccesstestcasecount">
                                                <xsl:value-of select="@totalsuccesstestcasecount" />
                                            </xsl:attribute>
                                            <xsl:attribute name="totalfailedtestcasecount">
                                                <xsl:value-of select="@totalfailedtestcasecount" />
                                            </xsl:attribute>
                                            <xsl:attribute name="totalblockedtestcasecount">
                                                <xsl:value-of select="@totalblockedtestcasecount" />
                                            </xsl:attribute>
                                        </div>
                                    </xsl:if>
                                </div>

                                <!--Test Case Filter Checkboxes -->
                                <div style="margin-top: 20px;">
                                    <xsl:call-template name="globalCategorySelector"></xsl:call-template>
                                </div>

                                <xsl:if test=".//item[@level='Warn']">
                                    <div class="warnmessage">
                                        <span class="ui-module-icon warn" />
                                        Warnings occurred. For additional information see the report of the individual modules, please.
                                    </div>
                                </xsl:if>
                                <xsl:if test="./activity[@type='integration']">
                                    <div class="integration-errormessage">
                                        <span class="ui-module-icon error" />
                                        Integration service
                                        <xsl:value-of select="./activity[@type='integration']/@integrationtype" />
                                        has encountered some errors.
                                        <a href="#integrationsection">Click here to navigate to the integration section.</a>
                                    </div>
                                </xsl:if>

                                <ul id="treeList" class="ui-treeList">

                                    <!-- PRE TEST SUITE BEGIN -->
                                    <xsl:if test="./activity/preceding-sibling::item">
                                        <li class="ui-treeList-item" id="pre-testsuite">
                                            <h2>
                                                Before Test Suite
                                                <xsl:if test="./activity/preceding-sibling::item[@level='Warn']">
                                                    <span class="ui-module-icon warn"></span>
                                                </xsl:if>
                                            </h2>
                                            <ul class="pre-testsuite">
                                                <div class="module-container" style="display:block">
                                                    <div class="module-header">
                                                        <xsl:call-template name="levelFilterSelector" />
                                                    </div>
                                                    <div class="module-report">
                                                        <TABLE border="0" cellSpacing="0" class="reporttable">
                                                            <thead>
                                                                <th>
                                                                    <b>Time</b>
                                                                </th>
                                                                <th>
                                                                    <b>Level</b>
                                                                </th>
                                                                <th>
                                                                    <b>Category</b>
                                                                </th>
                                                                <th>
                                                                    <b>Message</b>
                                                                </th>
                                                            </thead>

                                                            <tbody>
                                                                <xsl:apply-templates select="./activity/preceding-sibling::item" mode="nest">
                                                                    <xsl:with-param name="type">standalone</xsl:with-param>
                                                                </xsl:apply-templates>
                                                            </tbody>
                                                        </TABLE>
                                                    </div>
                                                </div>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                    <!-- PRE TEST SUITE END -->

                                    <xsl:if test="./activity[@type='test-suite']/params/param">
                                        <div class="dataparams dataparams-pre-testsuite">
                                            <xsl:apply-templates select="./activity[@type='test-suite']/params" mode="nest" />
                                        </div>
                                    </xsl:if>

                                    <xsl:choose>
                                        <xsl:when test="./activity[@type='test-suite']">
                                            <xsl:apply-templates select="./activity/activity | ./activity/item" mode="nest">
                                                <!-- Parameters for the activity type -->
                                                <xsl:with-param name="itemCount" select="$itemCount" />
                                                <!-- Parameters for the item type -->
                                                <xsl:with-param name="isSibling">true</xsl:with-param>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:apply-templates select="./activity" mode="nest">
                                                <xsl:with-param name="itemCount" select="$itemCount" />
                                            </xsl:apply-templates>
                                        </xsl:otherwise>
                                    </xsl:choose>

                                    <!-- POST TEST SUITE BEGIN -->
                                    <xsl:if test="./activity/following-sibling::item">
                                        <li class="ui-treeList-item" id="post-testsuite">
                                            <h2>
                                                After Test Suite
                                                <xsl:if test="./activity/following-sibling::item[@level='Warn']">
                                                    <span class="ui-module-icon warn"></span>
                                                </xsl:if>
                                            </h2>
                                            <ul class="pre-testsuite">
                                                <div class="module-container" style="display:block">
                                                    <div class="module-header">
                                                        <xsl:call-template name="levelFilterSelector" />
                                                    </div>
                                                    <div class="module-report">
                                                        <TABLE border="0" cellSpacing="0" class="reporttable">
                                                            <thead>
                                                                <th>
                                                                    <b>Time</b>
                                                                </th>
                                                                <th>
                                                                    <b>Level</b>
                                                                </th>
                                                                <th>
                                                                    <b>Category</b>
                                                                </th>
                                                                <th>
                                                                    <b>Message</b>
                                                                </th>
                                                            </thead>

                                                            <tbody>
                                                                <xsl:apply-templates select="./activity/following-sibling::item" mode="nest">
                                                                    <xsl:with-param name="type">standalone</xsl:with-param>
                                                                </xsl:apply-templates>
                                                            </tbody>
                                                        </TABLE>
                                                    </div>
                                                </div>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                    <!-- POST TEST SUITE END -->

                                    <!-- INTEGRATION SECTION BEGIN -->
                                    <xsl:if test="./activity[@type='integration']">
                                        <a name="integrationsection"></a>
                                        <li class="ui-treeList-item" id="integration-testsuite">
                                            <h2>
                                                <xsl:value-of select="./activity[@type='integration']/@integrationtype" />
                                                Report Section
                                            </h2>
                                            <ul class="pre-testsuite">
                                                <div class="module-report">
                                                    <TABLE border="0" cellSpacing="0" class="Integration">
                                                        <thead>
                                                            <th>
                                                                <b>Time</b>
                                                            </th>
                                                            <th>
                                                                <b>Level</b>
                                                            </th>
                                                            <th>
                                                                <b>Category</b>
                                                            </th>
                                                            <th>
                                                                <b>Message</b>
                                                            </th>
                                                        </thead>
                                                        <tbody>
                                                            <xsl:apply-templates select="./activity[@type='integration']/item" mode="nest">
                                                                <xsl:with-param name="type">standalone</xsl:with-param>
                                                            </xsl:apply-templates>
                                                        </tbody>
                                                    </TABLE>
                                                </div>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                    <!-- INTEGRATION SECTION END -->
                                </ul>
                            </xsl:when>

                            <!-- Standalone Recording Template-->
                            <xsl:otherwise>
                                <h1>
                                    <xsl:value-of select="@module" />
                                </h1>
                                <xsl:choose>
                                    <xsl:when test="../@progress != '' ">
                                        <div class="progress">
                                            <img alt="progress" width="16" height="6" src="data:image/gif;base64,R0lGODlhEAALAPQAAPPz8wAAANDQ0MbGxt/f3wUFBQAAACwsLHx8fFtbW7GxsSAgIEZGRoSEhF9fX7W1tSQkJAMDA0pKStzc3M7Ozunp6TU1NdLS0ufn566urpmZmcHBwePj4wAAAAAAAAAAACH+GkNyZWF0ZWQgd2l0aCBhamF4bG9hZC5pbmZvACH5BAALAAAAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAALAAAFLSAgjmRpnqSgCuLKAq5AEIM4zDVw03ve27ifDgfkEYe04kDIDC5zrtYKRa2WQgAh+QQACwABACwAAAAAEAALAAAFJGBhGAVgnqhpHIeRvsDawqns0qeN5+y967tYLyicBYE7EYkYAgAh+QQACwACACwAAAAAEAALAAAFNiAgjothLOOIJAkiGgxjpGKiKMkbz7SN6zIawJcDwIK9W/HISxGBzdHTuBNOmcJVCyoUlk7CEAAh+QQACwADACwAAAAAEAALAAAFNSAgjqQIRRFUAo3jNGIkSdHqPI8Tz3V55zuaDacDyIQ+YrBH+hWPzJFzOQQaeavWi7oqnVIhACH5BAALAAQALAAAAAAQAAsAAAUyICCOZGme1rJY5kRRk7hI0mJSVUXJtF3iOl7tltsBZsNfUegjAY3I5sgFY55KqdX1GgIAIfkEAAsABQAsAAAAABAACwAABTcgII5kaZ4kcV2EqLJipmnZhWGXaOOitm2aXQ4g7P2Ct2ER4AMul00kj5g0Al8tADY2y6C+4FIIACH5BAALAAYALAAAAAAQAAsAAAUvICCOZGme5ERRk6iy7qpyHCVStA3gNa/7txxwlwv2isSacYUc+l4tADQGQ1mvpBAAIfkEAAsABwAsAAAAABAACwAABS8gII5kaZ7kRFGTqLLuqnIcJVK0DeA1r/u3HHCXC/aKxJpxhRz6Xi0ANAZDWa+kEAA7AAAAAAAAAAAA" />
                                            <span style="padding-left:5px;">Test in progress</span>
                                        </div>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <h2 class="module {@result}">
                                            <span class="ui-status-icon"></span>
                                            <xsl:value-of select="@result" />
                                        </h2>
                                    </xsl:otherwise>
                                </xsl:choose>

                                <xsl:call-template name="executionInformation" />

                                <xsl:choose>
                                    <xsl:when test=".//item">
                                        <div style="margin-top: 20px;">
                                            <xsl:call-template name="levelFilterSelector" />
                                        </div>
                                        <div class="module-report" style="margin:15px 0 40px 0; position:relative;">
                                            <TABLE border="0" cellSpacing="0" class="reporttable">
                                                <thead>
                                                    <tr>
                                                        <th>
                                                            <b>Time</b>
                                                        </th>
                                                        <th>
                                                            <b>Level</b>
                                                        </th>
                                                        <th>
                                                            <b>Category</b>
                                                        </th>
                                                        <th>
                                                            <b>Message</b>
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <xsl:apply-templates select="./item" mode="nest">
                                                        <xsl:with-param name="type">standalone</xsl:with-param>
                                                    </xsl:apply-templates>
                                                </tbody>
                                            </TABLE>
                                        </div>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- No Item. -->
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                    <xsl:choose>
                        <xsl:when test="../@progress != '' ">
                            <div style="width:99%; text-align:center;padding-bottom: 10px;">
                                <div class="progress">
                                    <img alt="progress" width="16" height="11" src="data:image/gif;base64,R0lGODlhEAALAPQAAPPz8wAAANDQ0MbGxt/f3wUFBQAAACwsLHx8fFtbW7GxsSAgIEZGRoSEhF9fX7W1tSQkJAMDA0pKStzc3M7Ozunp6TU1NdLS0ufn566urpmZmcHBwePj4wAAAAAAAAAAACH+GkNyZWF0ZWQgd2l0aCBhamF4bG9hZC5pbmZvACH5BAALAAAAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAEAALAAAFLSAgjmRpnqSgCuLKAq5AEIM4zDVw03ve27ifDgfkEYe04kDIDC5zrtYKRa2WQgAh+QQACwABACwAAAAAEAALAAAFJGBhGAVgnqhpHIeRvsDawqns0qeN5+y967tYLyicBYE7EYkYAgAh+QQACwACACwAAAAAEAALAAAFNiAgjothLOOIJAkiGgxjpGKiKMkbz7SN6zIawJcDwIK9W/HISxGBzdHTuBNOmcJVCyoUlk7CEAAh+QQACwADACwAAAAAEAALAAAFNSAgjqQIRRFUAo3jNGIkSdHqPI8Tz3V55zuaDacDyIQ+YrBH+hWPzJFzOQQaeavWi7oqnVIhACH5BAALAAQALAAAAAAQAAsAAAUyICCOZGme1rJY5kRRk7hI0mJSVUXJtF3iOl7tltsBZsNfUegjAY3I5sgFY55KqdX1GgIAIfkEAAsABQAsAAAAABAACwAABTcgII5kaZ4kcV2EqLJipmnZhWGXaOOitm2aXQ4g7P2Ct2ER4AMul00kj5g0Al8tADY2y6C+4FIIACH5BAALAAYALAAAAAAQAAsAAAUvICCOZGme5ERRk6iy7qpyHCVStA3gNa/7txxwlwv2isSacYUc+l4tADQGQ1mvpBAAIfkEAAsABwAsAAAAABAACwAABS8gII5kaZ7kRFGTqLLuqnIcJVK0DeA1r/u3HHCXC/aKxJpxhRz6Xi0ANAZDWa+kEAA7AAAAAAAAAAAA" />
                                    <span style="padding-left:5px;">Test in progress</span>
                                </div>
                            </div>
                            <div style="width:100%; text-align:center;padding-bottom: 10px;">
                                <input type="submit" onclick="window.location.reload(false)" class="hyperlinkButton" value="Click here to refresh" />
                            </div>
                        </xsl:when>
                    </xsl:choose>
                    <div style="clear:both"></div>
                    <div id="Footer"></div>
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <!-- TESTCASE AND CONTAINER TEMPLATE -->
    <xsl:template match="activity[(@type='test-case' or @type='smart-folder' or @type='iteration-container' or @type='entry-container')
                                and not(@result='Pending')]" mode="nest">
        <xsl:param name="itemCount" />

        <xsl:variable name="activityclassname" select="concat(@type, ' ', @testentry-activity-type, ' ',@iteration-exectype, ' ', @activity-exectype)" />

        <li class="{@result} ui-treeList-item {$activityclassname}" id="container{@rid}">
            <xsl:variable name="success" select="@childsuccesscount" />
            <xsl:variable name="failed" select="@childfailedcount" />
            <xsl:variable name="ignored" select="@childblockedcount" />
            <xsl:variable name="max" select="$success + $failed + $ignored" />


            <h2 class="{@result}" onclick="OnLoadContentDynamic('{@rid}','container',this);" onMouseOver="DisplayHoverMenu(this);" onMouseOut="HideHoverMenu(this)">
                <!--JUMP TO-->
                <xsl:if test="./@testcontainerid">
                    <xsl:variable name="jumpToText">
                        <xsl:choose>
                            <xsl:when test="./@testentry-activity-type='testcase' or ./@type='test-case'">
                                <xsl:text>Jump to test case</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>Jump to smart folder</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <div class="controls-container testcase">
                        <a href="#" class="jump-to">
                            <metainfo id="{@testcontainerid}" type="{$activityclassname}" />
                            <span class="ui-icon"></span>
                            <xsl:value-of select="$jumpToText" />
                        </a>
                    </div>
                </xsl:if>

                <span class="ui-status-icon ui-treeList-toggle-child"></span>

                <span class="ui-icon {$activityclassname} ui-treeList-toggle-child"></span>

                <!--DISPLAY NAME TEXT-->
                <Span class="displayname {$activityclassname} ui-treeList-toggle-child">
                    <xsl:value-of select="./@displayName" />
                </Span>

                <xsl:if test="./@conditionstate='met'">
                    <span class="ui-module-icon conditionmet ui-treeList-toggle-child" />
                </xsl:if>
                <xsl:if test="./@conditionstate='notmet'">
                    <span class="ui-module-icon conditionnotmet ui-treeList-toggle-child" />
                </xsl:if>

                <!-- SHOW STATUS ICON - WARN, ERROR AND MAINTENANCEMODE-->
                <xsl:if test=".//item[@level='Warn']">
                    <span class="ui-module-icon warn ui-treeList-toggle-child" />
                </xsl:if>
                <xsl:if test=".//item[@level='Error' or @level='Failure']">
                    <span class="ui-module-icon error ui-treeList-toggle-child" />
                </xsl:if>
                <xsl:if test="@totalmaintenancemodecount &gt; 0">
                    <span class="ui-module-icon MaintenanceMode" title="Maintenance mode"></span>
                </xsl:if>

                <xsl:call-template name="VideoLink" />

                <xsl:call-template name="CustomLinks" />

                <!--ITERATION INFO TEXT-->
                <xsl:if test="@iteration-exectype or (@activity-exectype and @activity-exectype != 'execute')">
                    <span class="iterationinfo {$activityclassname} ui-treeList-toggle-child">
                        <xsl:choose>
                            <xsl:when test="@iteration-exectype = 'dataiteration'">
                                <xsl:text>Rows:</xsl:text>
                            </xsl:when>
                            <xsl:when test="@iteration-exectype = 'runiteration'">
                                <xsl:text>Iterations:</xsl:text>
                            </xsl:when>
                            <xsl:when test="@activity-exectype = 'dataiteration'">
                                <xsl:text>Data Row:</xsl:text>
                            </xsl:when>
                            <xsl:when test="@activity-exectype = 'runiteration'">
                                <xsl:text>Run:</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </span>
                    <strong class="iterationinfo {$activityclassname} ui-treeList-toggle-child">
                        <xsl:value-of select="concat(@dataiterationcount, @iterationCount, @iteration)" />
                    </strong>
                </xsl:if>

                <!--RETRY INFO TEXT-->
                <xsl:if test="@retry">
                    <span>
                        <span class="ui-module-icon retry ui-treeList-toggle-child" />
                        <span class="retryLabel">
                            <xsl:value-of select="@retry" />
                        </span>
                    </span>
                </xsl:if>

                <xsl:call-template name="ActivityDescription" />

                <xsl:if test="(@result='Success' or (@result='Failed' or @result='Active')) and $max &gt; 0">
                    <xsl:variable name="maxWidth" select="150" />
                    <xsl:variable name="widthSuccess">
                        <xsl:value-of select="round(($success div $max) * $maxWidth)" />
                    </xsl:variable>
                    <xsl:variable name="widthFailed">
                        <xsl:value-of select="round(($failed div $max) * $maxWidth)" />
                    </xsl:variable>
                    <xsl:if test="$widthSuccess &lt; $maxWidth and $widthFailed &lt; $maxWidth">
                        <div id="chart{@rid}" style="position: absolute; display:block; font-size:0; width:{$maxWidth}px; margin-top: 5px; right:60px;  height: 8px; background-color:#777; border:1px #979797 solid; overflow: hidden; top: 6px; ">
                            <div style="position: absolute; width:{$widthSuccess}px; height: 8px; background-color:#42af6f;"></div>
                            <div style="position: absolute; margin-left:{$widthSuccess}px;  width:{$widthFailed}px; height: 8px; background-color:#e10000; "></div>
                        </div>
                    </xsl:if>
                </xsl:if>
                <span class="duration">
                    <xsl:value-of select="./@duration" />
                </span>
            </h2>

            <ul>
                <!-- this section is here as a back up when dynamic loading is not available (currently for other non-IE browser) -->
                <!-- works the same for every UL in all the templates -->
                <xsl:call-template name="DetailedActivityDescription" />

                <xsl:if test="./errormessage">
                    <div class="errormessage">
                        <b class="message">
                            <xsl:value-of select="./errormessage" />
                        </b>
                    </div>
                </xsl:if>

                <xsl:if test="./params/param">
                    <div class="dataparams">
                        <xsl:apply-templates select="./params" mode="nest" />
                    </div>
                </xsl:if>
                <xsl:if test="./datarow/field">
                    <div class="datarow">
                        <xsl:apply-templates select="./datarow" mode="nest" />
                    </div>
                </xsl:if>

                <xsl:if test="$loadAll = 1">
                    <xsl:apply-templates select="./activity | ./item" mode="nest">
                        <xsl:with-param name="itemCount" select="$itemCount" />
                        <xsl:with-param name="isSibling">true</xsl:with-param>
                    </xsl:apply-templates>
                </xsl:if>
                <!-- section end -->
            </ul>
        </li>
    </xsl:template>

    <xsl:template match="datarow|params" mode="nest">
        <div class="binding">
            <div onclick="showBinding(this)" class="showBinding">
                <span class="binding-icon binding-icon-expand"></span>
                <a class="binding-header">Test data</a>
            </div>
            <div onclick="hideBinding(this)" class="hideBinding binding-hidden">
                <span class="binding-icon binding-icon-collapse"></span>
                <a class="binding-header">Test data</a>
            </div>
            <table class="binding-hidden">
                <xsl:for-each select="(field|param)[position() mod $cellsPerRow = 1]">
                    <tr>
                        <xsl:apply-templates select=".|(following-sibling::field|following-sibling::param)[position() &lt; $cellsPerRow]" mode="nest" />
                    </tr>
                </xsl:for-each>
            </table>
        </div>
    </xsl:template>

    <!--PARAMETER OR DATA COLUMN 'NAME - VALUE' TEMPLATE-->
    <xsl:template match="param|field" mode="nest">
        <td>
            <xsl:value-of select="./@name" />
            :
            <b>
                <xsl:value-of select="." />
            </b>
        </td>
    </xsl:template>

    <!-- SETUP and TEARDOWN TEMPLATE-->
    <xsl:template match="activity[@type='setup-container' or @type='teardown-container']" mode="nest">
        <xsl:param name="itemCount" />
        <li class="{@result} setup-teardown" id="container{@rid}">
            <h2 class="{@result}" onclick="OnLoadContentDynamic('{@rid}','container',this);">
                <span class="ui-status-icon"></span>
                <xsl:if test="@type='setup-container'">SETUP</xsl:if>
                <xsl:if test="@type='teardown-container'">TEARDOWN</xsl:if>

                <!-- SHOW STATUS ICON - WARN, ERROR AND MAINTENANCEMODE-->
                <xsl:if test=".//item[@level='Warn']">
                    <span class="ui-module-icon warn"></span>
                </xsl:if>
                <xsl:if test=".//item[@level='Error' or @level='Failure']">
                    <span class="ui-module-icon error"></span>
                </xsl:if>
                <xsl:if test="@totalmaintenancemodecount &gt; 0">
                    <span class="ui-module-icon MaintenanceMode" title="Maintenance mode"></span>
                </xsl:if>

                <xsl:call-template name="VideoLink" />

                <span class="duration">
                    <xsl:value-of select="./@duration" />
                </span>
            </h2>

            <ul>
                <xsl:if test="$loadAll = 1">
                    <xsl:apply-templates select="./activity" mode="nest">
                        <xsl:with-param name="itemCount" select="$itemCount" />
                    </xsl:apply-templates>
                </xsl:if>
            </ul>
        </li>
    </xsl:template>

    <!-- TEST MODULE TEMPLATE -->
    <xsl:template match="activity[@type='test-module']" mode="nest">
        <xsl:param name="itemCount" />
        <li>
            <h3 class="module-title {@result}" id="testmodule{@rid}" onclick="OnLoadContentDynamic('{@rid}','testmodule',this);">
                <a href="#">
                    <span class="ui-icon ui-icon-circle-triangle-e"></span>
                    <span class="ui-status-icon"></span>
                    <span class="ui-module-icon {@moduletype}"></span>
                    <xsl:value-of select="./@modulename" />

                    <!-- SHOW STATUS ICON - WARN, ERROR AND MAINTENANCEMODE-->
                    <xsl:if test=".//item[@level='Warn']">
                        <span class="ui-module-icon warn"></span>
                    </xsl:if>
                    <xsl:if test=".//item[@level='Error' or @level='Failure']">
                        <span class="ui-module-icon error"></span>
                    </xsl:if>
                    <xsl:if test="@totalmaintenancemodecount &gt; 0">
                        <span class="ui-module-icon MaintenanceMode" title="Maintenance mode"></span>
                    </xsl:if>

                    <i>
                        <xsl:value-of select="./detail" />
                    </i>
                    <span class="duration">
                        <xsl:value-of select="./@duration" />
                    </span>
                </a>
            </h3>
            <div class="module-container">
                <xsl:choose>
                    <xsl:when test=".//item">
                        <div class="module-header">
                            <xsl:call-template name="levelFilterSelector" />
                        </div>
                        <div class="module-report">
                            <TABLE border="0" cellSpacing="0" class="reporttable">
                                <thead>
                                    <th>
                                        <b>Time</b>
                                    </th>
                                    <th>
                                        <b>Level</b>
                                    </th>
                                    <th>
                                        <b>Category</b>
                                    </th>
                                    <th>
                                        <b>Message</b>
                                    </th>
                                </thead>

                                <tbody>
                                    <xsl:if test="$loadAll = 1">
                                        <xsl:apply-templates select="./item" mode="nest">
                                            <xsl:with-param name="type">testsuite</xsl:with-param>
                                        </xsl:apply-templates>
                                    </xsl:if>
                                </tbody>

                                <!-- additional metadata per module activity (added by mgi) -->
                                <xsl:copy-of select="./varbindings/varbinding" />
                            </TABLE>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- No Item. -->
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </li>
    </xsl:template>

    <!--
    MODULE GROUP TEMPLATE

    [Expand/Collapse][StatusIcon][ModulgroupIcon][ModuleGroupName] ... [Duration]
    -->
    <xsl:template match="activity[@type='module-group']" mode="nest">
        <xsl:param name="itemCount" />
        <li class="modulgroup {@result} ui-treeList-item">
            <h2 class="modulgroup {@result}">
                <span class="ui-status-icon"></span>
                <span class="ui-icon modulegroup"></span>
                <xsl:value-of select="./@modulegroupname" />

                <!-- SHOW STATUS ICON - WARN, ERROR AND MAINTENANCEMODE-->
                <xsl:if test=".//item[@level='Warn']">
                    <span class="ui-module-icon warn"></span>
                </xsl:if>
                <xsl:if test=".//item[@level='Error' or @level='Failure']">
                    <span class="ui-module-icon error"></span>
                </xsl:if>
                <xsl:if test="@totalmaintenancemodecount &gt; 0">
                    <span class="ui-module-icon MaintenanceMode" title="Maintenance mode"></span>
                </xsl:if>

                <xsl:call-template name="ActivityDescription" />

                <span class="duration">
                    <xsl:value-of select="./@duration" />
                </span>
            </h2>

            <ul>
                <xsl:call-template name="DetailedActivityDescription" />

                <!-- ModuleGroup Warn Messages -->
                <xsl:choose>
                    <xsl:when test="./item">
                        <div class="warnmessage" style="margin-top:8px; ">
                            <xsl:for-each select="./item">
                                <xsl:copy-of select="./message" />
                            </xsl:for-each>
                        </div>
                    </xsl:when>
                </xsl:choose>

                <!-- Sub Items of ModuleGroup -->
                <xsl:choose>
                    <xsl:when test="@result='Failed' or @result='Active' or @result='Ignored' or @result='Success'">
                        <xsl:apply-templates select="./activity" mode="nest">
                            <xsl:with-param name="itemCount" select="$itemCount" />
                        </xsl:apply-templates>
                    </xsl:when>
                </xsl:choose>
            </ul>
        </li>
    </xsl:template>

    <!--
    FOLDER TEMPLATE

    [Expand/Collapse][StatusIcon][FolderIcon][FolderName] ... [Duration]
    -->
    <xsl:template match="activity[@type='folder']" mode="nest">
        <xsl:param name="itemCount" />
        <li class="folder {@result} ui-treeList-item">
            <h2 class="folder {@result}">
                <span class="ui-status-icon"></span>
                <span class="ui-icon folder"></span>
                <xsl:value-of select="./@foldername" />

                <!-- SHOW STATUS ICON - WARN, ERROR AND MAINTENANCEMODE-->
                <xsl:if test=".//item[@level='Warn']">
                    <span class="ui-module-icon warn"></span>
                </xsl:if>
                <xsl:if test=".//item[@level='Error' or @level='Failure']">
                    <span class="ui-module-icon error"></span>
                </xsl:if>
                <xsl:if test="@totalmaintenancemodecount &gt; 0">
                    <span class="ui-module-icon MaintenanceMode" title="Maintenance mode"></span>
                </xsl:if>

                <xsl:call-template name="ActivityDescription" />

                <span class="duration">
                    <xsl:value-of select="./@duration" />
                </span>
            </h2>
            <ul>
                <xsl:call-template name="DetailedActivityDescription" />

                <xsl:choose>
                    <xsl:when test="@result='Failed' or @result='Active' or @result='Ignored' or @result='Success'">
                        <xsl:apply-templates select="./activity" mode="nest">
                            <xsl:with-param name="itemCount" select="$itemCount" />
                        </xsl:apply-templates>
                    </xsl:when>
                </xsl:choose>
            </ul>
        </li>
    </xsl:template>

    <!--
    ITEM TEMPLATE

    [Time]  [Level] [Category] [Message] (Hover -> Menu(Jump to Item, Edit in Spy ...))

    -->
    <xsl:template match="item" mode="nest">
        <xsl:param name="type" />
        <xsl:param name="isSibling" />

        <xsl:choose>
            <xsl:when test="$isSibling='true'">
                <div class="integrationmessage">
                    <xsl:if test="./metainfo/@logger='ReportLogger'">
                        <span class="ui-module-icon jira" />
                    </xsl:if>
                    <xsl:copy-of select="./message" />
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="tablerowclass">
                    <xsl:choose>
                        <xsl:when test="@category='MaintenanceMode'">
                            <xsl:value-of select="concat(translate(@level,' ','_'),' ', @category)" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="translate(@level,' ','_')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$type='standalone'">
                        <xsl:call-template name="itemrow">
                            <xsl:with-param name="tablerowclass" select="$tablerowclass" />
                            <xsl:with-param name="type" select="$type" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <table>
                            <xsl:call-template name="itemrow">
                                <xsl:with-param name="tablerowclass" select="$tablerowclass" />
                                <xsl:with-param name="type" select="$type" />
                            </xsl:call-template>
                        </table>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="itemrow">
        <xsl:param name="tablerowclass" />
        <xsl:param name="type" />

        <tr class="{$tablerowclass}" style="{@style}" onMouseOver="DisplayHoverMenu(this)" onMouseOut="HideHoverMenu(this)">
            <td class="timeCell">
                <xsl:value-of select="./@time" />
            </td>
            <td class="levelCell">
                <xsl:value-of select="./@level" />
            </td>
            <td class="categoryCell">
                <xsl:value-of select="./@category" />
            </td>
            <td class="messageCell {$type}">
                <xsl:if test="metainfo">
                    <xsl:variable name="controls-class">
                        <xsl:choose>
                            <xsl:when test="./metainfo/@path and (@level='Error' or @level='Warn')">
                                <xsl:text>controls-container three-columns</xsl:text>
                            </xsl:when>
                            <xsl:when test="./metainfo/@path or @level='Error' or @level='Warn'">
                                <xsl:text>controls-container two-columns</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>controls-container</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <!-- Jump-To Popup -->
                    <xsl:if test="not(@category = 'Popup Watcher')">
                        <!-- No jump-to possible for Popup Watcher -->
                        <xsl:if test="./metainfo/@id or ./metainfo/@path or ((./metainfo/@codefile and ./metainfo/@codeline) or  ./metainfo/@itemindex) or (@level='Error' or @level='Warn')">
                            <div class="{$controls-class}">
                                <xsl:if test="(./metainfo/@codefile and ./metainfo/@codeline) or  ./metainfo/@itemindex or ./metainfo/@id">
                                    <a href="#" class="jump-to">
                                        <xsl:copy-of select="./metainfo" />
                                        <span class="ui-icon"></span>
                                        Jump to item
                                    </a>
                                    <xsl:if test="@errimg and ./metainfo/@replaceImage='true'">
                                        <a href="#" class="replace-reference-img">
                                            <metainfo codefile="{./metainfo/@codefile}" itemindex="{./metainfo/@itemindex}" img="{@errimg}" />
                                            <span class="ui-icon"></span>
                                            Replace expected image
                                        </a>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:if test="./metainfo/@matchvalue and @level='Success' and @category='MaintenanceMode'">
                                    <a href="#" class="apply-match">
                                        <xsl:copy-of select="./metainfo" />
                                        <span class="ui-icon"></span>
                                        Apply new value
                                    </a>
                                </xsl:if>
                                <xsl:if test="./metainfo/@path and @level='Success' and @category='MaintenanceMode'">
                                    <xsl:if test="./metainfo/@hasvars='True'">
                                        <a href="#" class="edit-in-spy" id="hasVars">
                                            <xsl:copy-of select="./metainfo" />
                                            <span class="ui-icon"></span>
                                            Edit path manually
                                        </a>
                                    </xsl:if>
                                    <xsl:if test="./metainfo/@hasvars='False'">
                                        <a href="#" class="edit-in-spy" id="noVars">
                                            <xsl:copy-of select="./metainfo" />
                                            <span class="ui-icon"></span>
                                            Apply path changes
                                        </a>
                                    </xsl:if>
                                </xsl:if>
                                <xsl:if test="./metainfo/@path">
                                    <a href="#" class="spy">
                                        <xsl:copy-of select="./metainfo" />
                                        <span class="ui-icon"></span>
                                        <span class="spytext">Edit in Spy</span>
                                    </a>
                                </xsl:if>
                                <xsl:if test="@level='Error' or @level='Warn'">
                                    <a href="#" class="help">
                                        <span class="ui-icon"></span>
                                        View Help
                                    </a>
                                </xsl:if>
                            </div>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>

                <xsl:copy-of select="./message" />

                <xsl:if test="./metainfo/@stacktrace">
                    <div class="stacktrace">
                        <span onclick="$(this).next().toggle();">Show/Hide Stacktrace</span>
                        <p>
                            <xsl:value-of select="./metainfo/@stacktrace" />
                        </p>
                    </div>
                </xsl:if>

                <xsl:if test="@errimg">
                    <br />
                    <a href="{@errimg}" class="thickbox" rel="modulename">
                        <img src="{@errthumb}" alt="Screenshot" />
                    </a>
                </xsl:if>

                <xsl:if test="./metainfo/@warningMessage">
                    <div class="warningMessage">
                        <span class="ui-icon"></span>
                        <xsl:value-of select="./metainfo/@warningMessage" />
                    </div>
                </xsl:if>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="levelFilterSelector">
        <div class="filter">
            <span>Filter: </span>
            <xsl:if test=".//item[@level='Debug']">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select=".//item[@level='Debug']" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//item[@level='Info']">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select=".//item[@level='Info']" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//item[@level='Warn']">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select=".//item[@level='Warn']" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//item[@level='Error']">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select=".//item[@level='Error']" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//item[@level='Success']">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select=".//item[@level='Success']" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//item[@level='Failure']">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select=".//item[@level='Failure']" />
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select=".//item[not(@level=preceding-sibling::item/@level) and not(@level='Debug' or @level='Info' or @level='Warn' or @level='Error' or @level='Success' or @level='Failure')]">
                <xsl:call-template name="levelFilterCheckbox">
                    <xsl:with-param name="level" select="." />
                </xsl:call-template>
            </xsl:for-each>
            <form>
              <div class="multiselect" >
                    <xsl:variable name="categoryId">
                        <xsl:value-of select="generate-id(.//item)" />
                     </xsl:variable>
                <div class="selectBox" onclick="showCheckboxes($(this),'checkboxes{$categoryId}')">
                  <select>
                    <option>Category</option>
                  </select>
                  <div class="overSelect"></div>
                </div>
                <div class ="checkboxes" id="checkboxes{$categoryId}">
                  <label for= "selectAll{$categoryId}">
                  <input type="checkbox" class="categorycheckbox" name="selectAll" id="selectAll{$categoryId}" onClick="ShowHideItemCategory($(this).parent().parent().parent().parent().parent().parent(),true)" checked="1" /><b>Select all</b></label>
                  <hr/>
                  <xsl:for-each select=".//item[not(@category=preceding-sibling::item/@category) ]">
                     <xsl:sort select="@category" data-type="text" order="ascending"/>
                     <xsl:choose>
                        <xsl:when test="../../activity[@type='test-module']">
                            <label for= "{@category}{$categoryId}">
                            <input type="checkbox" class="categorycheckbox" name="{@category}" id="{@category}{$categoryId}" onClick="ShowHideItemCategory($(this).parent().parent().parent().parent().parent().parent())" checked="1" /><xsl:value-of select="@category" /></label>
                        </xsl:when>
                        <xsl:otherwise>
                            <label for= "{@category}{$categoryId}">
                            <input type="checkbox" class="categorycheckbox" name="{@category}" id="{@category}{$categoryId}" onClick="ShowHideItemCategory($(this).parent().parent().parent().parent().parent().parent())" checked="1" /><xsl:value-of select="@category" /></label>
                        </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </div>
              </div>
            </form>
        </div>
    </xsl:template>

    <xsl:template name="levelFilterCheckbox">
        <xsl:param name="level" />
        <xsl:variable name="currentId">
            <xsl:value-of select="generate-id($level)" />
        </xsl:variable>
        <xsl:variable name="levelName">
            <xsl:value-of select="$level/@level" />
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$level/../../activity[@type='test-module']">
                <input type="checkbox" id="checkBox{$currentId}" name="checkBox{$currentId}" onClick="ShowHideItemCategory($(this).parent().parent());" checked="1" />
            </xsl:when>
            <xsl:otherwise>
                <input type="checkbox" id="checkBox{$currentId}" name="checkBox{$currentId}" onClick="ShowHideItemCategory($(this).parent().parent());" checked="1" />
            </xsl:otherwise>
        </xsl:choose>

        <label for="checkBox{$currentId}">
            <xsl:value-of select="$levelName" />
        </label>
    </xsl:template>

    <xsl:template name="globalCategorySelector">
        <div class="filter">
            <span>Test container filter:</span>
            <input type="checkbox" id="checkBoxTestCaseSuccess" name="checkBoxTestCaseSuccess" onClick="OnFilter(this,['li.Success'])" checked="1" />
            <label for="checkBoxTestCaseSuccess">Success</label>
            <input type="checkbox" id="checkBoxTestCaseFailed" name="checkBoxTestCaseFailed" onClick="OnFilter(this,['li.Failed','li.Active'])" checked="1" />
            <label for="checkBoxTestCaseFailed">Failed</label>
            <input type="checkbox" id="checkBoxTestCaseIgnored" name="checkBoxTestCaseIgnored" onClick="OnFilter(this,['li.Ignored'])" checked="1" />
            <label for="checkBoxTestCaseIgnored">Blocked</label>
        </div>
    </xsl:template>

    <xsl:template name="executionInformation">
        <div class="execution-information">
            <table>
                <tr>
                    <td>
                        <i class="field">
                            Computer/Endpoint
                            <b>
                                <xsl:call-template name="break">
                                    <xsl:with-param name="text" select="@host" />
                                </xsl:call-template>
                            </b>
                        </i>
                    </td>
                    <td>
                        <i class="field">
                            Execution time
                            <b>
                                <xsl:value-of select="@timestamp" />
                            </b>
                        </i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <i class="field">
                            Username
                            <b>
                                <xsl:value-of select="@user" />
                            </b>
                        </i>
                    </td>
                    <td>
                        <i class="field">
                            Run configuration name
                            <b>
                                <xsl:value-of select="./activity/@runconfigname" />
                            </b>
                        </i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <i class="field">
                            Operating system
                            <b>
                                <xsl:value-of select="@osversion" />
                            </b>
                        </i>
                    </td>
                    <td>
                        <i class="field">
                            Screen dimensions
                            <b>
                                <xsl:value-of select="@screenresolution" />
                            </b>
                        </i>
                    </td>
                </tr>
                <tr>
                    <td>
                        <i class="field">
                            OS Language
                            <b>
                                <xsl:value-of select="@oslanguage" />
                            </b>
                        </i>
                    </td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="./activity[@type='test-suite']">
                                <i class="field">
                                    Duration
                                    <b>
                                        <xsl:value-of select="./activity[@type='test-suite']/./@duration" />
                                    </b>
                                </i>
                            </xsl:when>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:if test="@timeoutfactor != '1'">
                    <tr>
                        <td>
                            <i class="field">
                                Timeout factor
                                <b>
                                    <xsl:value-of select="@timeoutfactor" />
                                </b>
                            </i>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <xsl:if test="@totalerrorcount">

                        <td>
                            <i class="field">
                                Total errors
                                <b>
                                    <xsl:value-of select="@totalerrorcount" />
                                </b>
                            </i>
                        </td>
                    </xsl:if>
                    <xsl:if test="@totalwarningcount">

                        <td>
                            <i class="field">
                                Total warnings
                                <b>
                                    <xsl:value-of select="@totalwarningcount" />
                                </b>
                            </i>
                        </td>
                    </xsl:if>
                </tr>
            </table>
        </div>
    </xsl:template>

    <xsl:template name="ActivityDescription">
        <xsl:variable name="detailstextesc">
            <xsl:call-template name="remove-html">
                <xsl:with-param name="text" select="./detail" />
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="detailstext">
            <xsl:value-of select="substring-after($detailstextesc,substring-before($detailstextesc, substring(normalize-space($detailstextesc),1,1)))" />
        </xsl:variable>

        <i class="description">
            <xsl:if test="string-length(normalize-space(./conditionmsg)) > 0">
                <xsl:value-of select="./conditionmsg" />
            </xsl:if>

            <xsl:value-of select="substring($detailstext,0,70)" />
            <xsl:if test="string-length($detailstext) &gt; 70">...</xsl:if>
        </i>
    </xsl:template>

    <xsl:template name="DetailedActivityDescription">
        <xsl:if test="string-length(normalize-space(./detail)) > 0 or string-length(normalize-space(./conditionmsg)) > 0">
            <div class="htmlDescription dataparams">
                <xsl:if test="string-length(normalize-space(./conditionmsg)) > 0">
                    <xsl:value-of select="./conditionmsg" />
                    <xsl:if test="string-length(normalize-space(./detail)) > 0">
                        <br />
                        <br />
                    </xsl:if>
                </xsl:if>
                <div class="literalHtml">
                    <xsl:value-of select="./detail" disable-output-escaping="yes" />
                </div>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="remove-html">
        <xsl:param name="text" />
        <xsl:choose>
            <xsl:when test="contains($text, '&lt;')">
                <xsl:value-of select="substring-before($text, '&lt;')" />
                <xsl:call-template name="remove-html">
                    <xsl:with-param name="text" select="substring-after($text, '&gt;')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="break">
        <xsl:param name="text" select="string(.)" />
        <xsl:choose>
            <xsl:when test="contains($text, '&#xa;')">
                <xsl:value-of select="substring-before($text, '&#xa;')" />
                <br />
                <xsl:call-template name="break">
                    <xsl:with-param name="text" select="substring-after($text, '&#xa;')" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$text" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="VideoLink">
        <xsl:if test="./@videofile != ''">
            <xsl:variable name="url" select="./@videofile" />
            <span class="video-button">
                <a href="{$url}">
                    <span class="ui-module-icon video"></span>
                    <span class="video-button-label">Play video</span>
                </a>
            </span>
        </xsl:if>
    </xsl:template>
    <xsl:template name="CustomLinks">
        <!-- Jira link for test case without iterations -->
        <xsl:if test="./custom/@JiraManControlLink != '' and not(@activity-exectype and @activity-exectype != 'execute')">
            <xsl:variable name="url" select="./custom/@JiraManControlLink" />
            <span class="jira-button">
                <a href="{$url}">
                    <span class="ui-module-icon jira"></span>
                    <span class="jira-button-label">Create Jira issue</span>
                </a>
            </span>
        </xsl:if>
        <!-- Jira link for test case with iterations -->
        <xsl:if test=".//custom/@JiraManControlLink != '' and @iteration-exectype and @testentry-activity-type='testcase'">
            <xsl:variable name="url" select=".//custom/@JiraManControlLink" />
            <span class="jira-button">
                <a href="{$url}">
                    <span class="ui-module-icon jira"></span>
                    <span class="jira-button-label">Create Jira issue</span>
                </a>
            </span>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>

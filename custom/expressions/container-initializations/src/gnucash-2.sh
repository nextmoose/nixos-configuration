#!/bin/sh

TEMP_DIR=$(mktemp -d) &&
    cp -r ${HOME} ${TEMP_DIR}/t.00 &&
secrets \
    --canonical-host github.com \
    --canonical-organization nextmoose \
    --canonical-repository secrets \
    --canonical-branch master &&
    ssh-remote \
	--remote upstream \
	--host github.com \
	--user git \
	--port 22 &&
    read-only-pass \
	--upstream-organization nextmoose \
	--upstream-repository aws-secrets \
	--upstream-branch master &&
    aws \
	--aws-access-key-id AKIAICSO2M2FPGDMRHNA \
	--default-region-name us-east-1 \
	--default-output-format json &&
    mkdir ${HOME}/.dbus &&
    mkdir ${HOME}/.dbus/session-bus &&
    cat /etc/machine-id &&
    ls -alh ${HOME}/.dbus/session-bus &&
    (cat > ${HOME}/.dbus/session-bus/$(cat /etc/machine-id) <<EOF
DBUS_SESSION_BUS_ADDRESS='unix:abstract=/tmp/dbus-1GjpeKdRji,guid=68ba1d8e3160a03de952dccd5bdc63d5'
DBUS_SESSION_BUS_PID=309
DBUS_SESSION_BUS_WINDOWID=25165825
EOF
    ) &&
    mkdir ${HOME}/.gconf &&
    mkdir ${HOME}/.gconf/apps &&
    touch ${HOME}/.gconf/apps/%gconf.xml &&
    mkdir ${HOME}/.gconf/apps/gnucash &&
    touch ${HOME}/.gconf/apps/gnucash/%gconf.xml &&
    mkdir ${HOME}/.gconf/apps/gnucash/general &&
    (cat > ${HOME}/.gconf/apps/gnucash/general/%gconf.xml <<EOF
<?xml version="1.0"?>
<gconf>
	<entry name="date_backmonths" mtime="1541170143" type="float" value="6"/>
	<entry name="date_completion" mtime="1541170143" type="string">
		<stringvalue>thisyear</stringvalue>
	</entry>
</gconf>
EOF
     ) &&
    mkdir ${HOME}/.gconfd &&
    touch ${HOME}/.gconfd/saved_state &&
    (cat > ${HOME}/.gconf.path <<EOF
xml:readonly:/nix/store/p3wdpwf9aaqvr7qxhwmk3cn8lfdk089v-gnucash-2.4.15/etc/gconf/gconf.xml.defaults
EOF
    ) &&
    mkdir ${HOME}/.gnome2 &&
    mkdir ${HOME}/.gnome2/accels &&
    mkdir ${HOME}/.gnome2_private &&
    mkdir ${HOME}/.gnucash &&
    (cat > ${HOME}/.gnucash/accelerator-map <<EOF
; gnucash GtkAccelMap rc-file         -*- scheme -*-
; this file is an automated accelerator map dump
;
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessTestSearchAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-qif-import-actions/QIFImportAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/44f81bee049b4b3ea908f8dac9a9474eAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/HelpAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ActionsAutoClearAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/e6e34fa3b6e748debde3cb3bc76d3e53Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorNewBillOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/FileSaveAction" "<Primary>s")
; (gtk_accel_path "<Actions>/MenuAdditions/47f45d7d6d57b68518481c1fc8d4e4baAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerNewInvoiceOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/EmployeeNewExpenseVoucherOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABGetBalanceAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window7Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-register-actions/ToolsGeneralLedgerAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window0Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/HelpTipsOfTheDayAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABSetupAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/Mt942ImportAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/WindowsAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ActionsScheduledTransactionsAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ActionsMortgageLoanAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/FileSaveAsAction" "<Primary><Shift>s")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ActionsTransferAction" "<Primary>t")
; (gtk_accel_path "<Actions>/MenuAdditions/ad80271c890b11dfa79f2dcedfd72085Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABIssueIntTransAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/9cf76bed17f14401b8e3e22d0079cb98Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window9Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/OnlineActionsAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/FileAddAccountHierarchyDruidAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window2Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/1d241609fd4644caad765c95be20ff4cAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/EmployeeFindEmployeeOpenAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ToolsAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-budget-actions/CopyBudgetAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/4d3dcdc8890b11df99dd94cddfd72085Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FilePageSetupAction" "<Primary><Shift>p")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile9Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BillsDueReminderOpenAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/5518ac227e474f47a34439f2d4d049deAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/FileOpenAction" "<Primary>o")
; (gtk_accel_path "<Actions>/MainWindowActions/ExtensionsAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/5e2d129f28d14df881c3e47e3053f604Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-budget-actions/OpenBudgetAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile2Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-log-replay-actions/LogReplayAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorFindVendorOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-ofx-actions/OfxImportAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/FileNewAccountAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorFindBillOpenAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ActionsAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ActionsForgetWarningsAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/WindowMovePageAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/3fe6dce77da24c66bdc8f8efdea7f9acAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile4Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessTestAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/EditCutAction" "<Primary>x")
; (gtk_accel_path "<Actions>/gnc-plugin-account-tree-actions/ViewAccountTreeAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/EditDeleteAccountAction" "Delete")
; (gtk_accel_path "<Actions>/MenuAdditions/3ce293441e894423a2425d7a22dd1ac6Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerFindInvoiceOpenAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ScrubMenuAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/EditRenumberSubaccountsAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/EditCopyAction" "<Primary>c")
; (gtk_accel_path "<Actions>/MainWindowActions/HelpContentsAction" "F1")
; (gtk_accel_path "<Actions>/MenuAdditions/898d78ec92854402bf76e20a36d24adeAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/cbba1696c8c24744848062c7f1cf4a72Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window8Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewToolbarAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window1Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/2e3751edeb7544e8a20fd19e9d08bb65Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/EditPasteAction" "<Primary>v")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorNewJobOpenAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/FileOpenAccountAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-stylesheets-actions/EditStyleSheetsAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/EditPreferencesAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ActionsScheduledTransactionEditorAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FileAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/WindowNewAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/d5adcc61c62e4b8684dd8907448d7900Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FilePrintAction" "<Primary>p")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/EmployeeFindExpenseVoucherOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorProcessPaymentAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window3Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABIssueTransAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/80769921e87943adade887b9835a7685Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessTestReloadOwnerAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessTestReloadInvoiceAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABViewLogwindowAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/d8b63264186b11e19038001558291366Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/dde49fed4ca940959ae7d01b72742530Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerNewCustomerOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ToolsFinancialCalculatorAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/FileNewAction" "<Primary>n")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window5Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABGetTransAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessTestReloadReceivableAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorMenuAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/5123a759ceb9483abf2182d01c140e8dAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/__BusinessAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerFindJobOpenAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ScrubAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/EmployeeMenuAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/8758ba23984c40dea5527f5f0ca2779eAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/c4173ac99b2b448289bf4d11c731af13Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ActionsLotsAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ActionsBudgetAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FilePropertiesAction" "<Alt>Return")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/EditFindTransactionsAction" "<Primary>f")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile5Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/e57770f2dbca46619d6dac4ac5469b50Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ScrubSubAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewSortByAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BusinessTestInitDataAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/Mt940ImportAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/810ed4b25ef0486ea43bbd3dddb32b11Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/5c7fd8a1fe9a4cd38884ff54214aa88aAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/67112f318bef4fc496bdc27d106bbda4Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/2fe3b9833af044abb929a88d5a59620fAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ReportsAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ToolsCommodityEditorAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile7Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ActionsReconcileAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile0Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/9bf1892805cb4336be6320fe48ce5446Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/c146317be32e4948a561ec7fc89d15c1Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window4Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FileExportAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/e1bd09b8a1dd49dd85760db9d82b045cAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/2e22929e5c5b4b769f615a815ef0c20fAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/d7d1e53505ee4b1b82efad9eacedaea0Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/ABIssueDirectDebitAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ToolsBookCloseAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/__Assets_ _&_ LiabilitiesAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ActionsSinceLastRunAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerFindCustomerOpenAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/f8921f4e5c284d7caca81e239f468a68Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/ToolsPriceEditorAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/583c313fcc484efc974c4c844404f454Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/EmployeeProcessPaymentAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FileImportAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/b1f15b2052c149df93e698fe85a81ea6Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ActionsRenamePageAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerMenuAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerProcessPaymentAction" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/FileOpenSubaccountsAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/c2a996c8970f43448654ca84f17dda24Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/f8748b813fab4220ba26e743aedf38daAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/21d7cfc59fc74f22887596ebde7e462dAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FileCloseAction" "<Primary>w")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewStatusbarAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/Window6Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/25455562bd234dd0b048ecc5a8af9e43Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewFilterByAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/HelpTutorialAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-budget-actions/NewBudgetAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/e5fa5ce805e840ecbeca4dba3fa4ead9Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/HelpAboutAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/d8ba4a2e89e8479ca9f6eccdeb164588Action" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/415cd38d39054d9e9c4040455290c2b1Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/EditEditAccountAction" "<Primary>e")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewRefreshAction" "<Primary>r")
; (gtk_accel_path "<Actions>/MenuAdditions/e9cf815f79db44bcb637d0295093ae3dAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile6Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/EditTaxOptionsAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/4a6b82e8678c4f3d9e85d9f09634ca89Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/EmployeeNewEmployeeOpenAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/08ae9c2e884b4f9787144f47eacd7f44Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ViewFilterByAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/faf410e8f8da481fbc09e4763da40bccAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/__Income_ _&_ ExpenseAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorFindJobOpenAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/FileQuitAction" "<Primary>q")
; (gtk_accel_path "<Actions>/gnc-plugin-csv-actions/CsvImportAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/ViewSummaryAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/BillingTermsOpenAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/4166a20981985fd2b07ff8cb3b7d384eAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/DtausImportSendAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile8Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/3298541c236b494998b236dfad6ad752Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/0769e242be474010b4acf264a5512e6eAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile1Action" "")
; (gtk_accel_path "<Actions>/MenuAdditions/ecc35ea9dbfa4e20ba389fc85d59cb69Action" "")
; (gtk_accel_path "<Actions>/gnc-plugin-aqbanking-actions/DtausImportAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/216cd0cf6931453ebcce85415aba7082Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ScrubAllAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/__Sample_ _&_ CustomAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/B__udgetAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-basic-commands-actions/FileExportAccountsAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/EditAction" "")
; (gtk_accel_path "<Actions>/MenuAdditions/0b81a3bdfd504aff849ec2e8630524bcAction" "")
; (gtk_accel_path "<Actions>/MainWindowActions/TransactionAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-file-history-actions/RecentFile3Action" "")
; (gtk_accel_path "<Actions>/GncPluginPageAccountTreeActions/ActionsStockSplitAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/TaxTablesOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/CustomerNewJobOpenAction" "")
; (gtk_accel_path "<Actions>/gnc-plugin-business-actions/VendorNewVendorOpenAction" "")
EOF
    ) &&
    mkdir ${HOME}/.gnucash/books &&
    mkdir ${HOME}/.gnucash/checks &&
    touch ${HOME}/.gnucash/expressions-2.0 &&
    (cat > ${HOME}/.gnucash/stylesheets-2.0 <<EOF
(let ((template (gnc:html-style-sheet-template-find "Fancy")))
  (if template 
    (let ((options ((gnc:html-style-sheet-template-options-generator template)))) 

; Section: Colors


; Section: Images


; Section: General


; Section: Tables


; Section: Fonts

 (gnc:restore-html-style-sheet "Technicolor" "Fancy" options))))
(let ((template (gnc:html-style-sheet-template-find "Footer")))
  (if template 
    (let ((options ((gnc:html-style-sheet-template-options-generator template)))) 

; Section: Colors


; Section: Images


; Section: General


; Section: Tables


; Section: Fonts

 (gnc:restore-html-style-sheet "Footer" "Footer" options))))
(let ((template (gnc:html-style-sheet-template-find "Plain")))
  (if template 
    (let ((options ((gnc:html-style-sheet-template-options-generator template)))) 

; Section: Colors


; Section: General


; Section: Tables


; Section: Fonts

 (gnc:restore-html-style-sheet "Default" "Plain" options))))
(let ((template (gnc:html-style-sheet-template-find "Easy")))
  (if template 
    (let ((options ((gnc:html-style-sheet-template-options-generator template)))) 

; Section: Colors


; Section: Images


; Section: General


; Section: Tables


; Section: Fonts

 (gnc:restore-html-style-sheet "Easy" "Easy" options))))
EOF
    ) &&
    mkdir ${HOME}/.gnucash/translog &&
    cp -r ${HOME} ${TEMP_DIR}/t.01 &&
    sleep 10s &&
    echo &&
    echo BUCKET=${BUCKET} &&
    echo ${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} &&
    which aws &&
    ls -alh $(which aws) &&
    ${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} &&
    TSTAMP=$(${AWS_PATH}/bin/aws s3 ls s3://${BUCKET} | sort | head --lines 1 | cut --bytes 40-49) &&
    echo TSTAMP="${TSTAMP}" &&
    debucket --name gnucash --timestamp "${TSTAMP}" --destination-directory gnucash &&
    sleep 10s &&
    gnucash gnucash/gnucash.gnucash &&
    cp -r ${HOME} ${TEMP_DIR}/t.02 &&
    true

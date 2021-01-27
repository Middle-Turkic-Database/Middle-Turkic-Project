<?php
defined('TYPO3_MODE') || die();

/***************
 * Add default RTE configuration
 */
$GLOBALS['TYPO3_CONF_VARS']['RTE']['Presets']['middle_turkic_project'] = 'EXT:middle_turkic_project/Configuration/RTE/Default.yaml';

/***************
 * PageTS
 */
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addPageTSConfig('<INCLUDE_TYPOSCRIPT: source="FILE:EXT:middle_turkic_project/Configuration/TsConfig/Page/All.tsconfig">');

/***************
 * Wizards
 */
\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addPageTSConfig('<INCLUDE_TYPOSCRIPT: source="FILE:EXT:middle_turkic_project/Configuration/TsConfig/Page/Mod/Wizards/NewContentElement.tsconfig">');


/***************
 * File_List Layout
 */
$boot = function ($_EXTKEY) {

    /* ===========================================================================
        Register an "image gallery" layout
    =========================================================================== */
    $GLOBALS['TYPO3_CONF_VARS']['EXT']['file_list']['templateLayouts'][] = [
        'Manuscripts', // You may use a LLL:EXT: label reference here of course!
        'ManuscriptListPartial',
    ];
};

$boot($_EXTKEY);
unset($boot);

/***************
 * File_List Custom Language
 */

$GLOBALS['TYPO3_CONF_VARS']['SYS']['locallangXMLOverride']['EXT:file_list/Resources/Private/Language/locallang.xlf'][] = 'EXT:middle_turkic_project/Resources/Private/Language/locallang_file_list.xlf';


/***************
 * mask Folders
 */
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['json'] = 'EXT:middle_turkic_project/Resources/Private/Mask/mask.json';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['content'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Frontend/Templates/';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['layouts'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Frontend/Layouts/';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['partials'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Frontend/Partials/';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['backend'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Backend/Templates/';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['layouts_backend'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Backend/Layouts/';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['partials_backend'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Backend/Partials/';
$GLOBALS['TYPO3_CONF_VARS']['EXTENSIONS']['mask']['preview'] = 'EXT:middle_turkic_project/Resources/Private/Mask/Backend/Previews/';

/***************
 * Register custom EXT:form configuration
 */
if (\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::isLoaded('form')) {
    \TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTypoScriptSetup(trim('
        module.tx_form {
            settings {
                yamlConfigurations {
                    200 = EXT:middle_turkic_project/Configuration/Form/Setup.yaml
                }
            }
        }
        plugin.tx_form {
            settings {
                yamlConfigurations {
                    200 = EXT:middle_turkic_project/Configuration/Form/Setup.yaml
                }
            }
        }
    '));
}

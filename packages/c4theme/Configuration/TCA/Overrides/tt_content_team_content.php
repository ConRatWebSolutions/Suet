<?php

declare(strict_types=1);

defined('TYPO3') or die();

if (!is_array($GLOBALS['TCA']['tt_content']['types']['team_content'] ?? null)) {
    $GLOBALS['TCA']['tt_content']['types']['team_content'] = [];
}

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    [
        'label' => 'LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:content_element.team_content',
        'value' => 'team_content',
        'icon' => 'content-c4theme-team',
        'group' => 'c4theme',
    ],
    'video_content',
    'after'
);

$GLOBALS['TCA']['tt_content']['ctrl']['typeicon_classes']['team_content'] = 'content-c4theme-team';

$GLOBALS['TCA']['tt_content']['columns']['tx_c4theme_email'] = [
    'label' => 'LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:team_content.email',
    'config' => [
        'type' => 'input',
        'size' => 40,
        'max' => 255,
        'eval' => 'trim,email',
        'placeholder' => 'email@beispiel.de',
    ],
];

$GLOBALS['TCA']['tt_content']['types']['team_content'] = array_replace_recursive(
    $GLOBALS['TCA']['tt_content']['types']['team_content'],
    [
        'showitem' => '
            --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:general,
                --palette--;;general,
                header;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:header_formlabel,
                subheader;LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:team_content.title,
                bodytext;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:bodytext_formlabel,
                tx_c4theme_email;LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:team_content.email,
                image;LLL:EXT:core/Resources/Private/Language/locallang_general.xlf:LGL.images,
            --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:access,
                --palette--;;visibility,
                --palette--;;access,
            --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:extended
        ',
    ]
);

<?php

declare(strict_types=1);

defined('TYPO3') or die();

if (!is_array($GLOBALS['TCA']['tt_content']['types']['video_content'] ?? null)) {
    $GLOBALS['TCA']['tt_content']['types']['video_content'] = [];
}

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItemGroup(
    'tt_content',
    'CType',
    'c4theme',
    'LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:content_group.c4theme',
    'after:media'
);

\TYPO3\CMS\Core\Utility\ExtensionManagementUtility::addTcaSelectItem(
    'tt_content',
    'CType',
    [
        'label' => 'LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:content_element.video_content',
        'value' => 'video_content',
        'icon' => 'content-c4theme-video',
        'group' => 'c4theme',
    ],
    'textmedia',
    'after'
);

$GLOBALS['TCA']['tt_content']['ctrl']['typeicon_classes']['video_content'] = 'content-c4theme-video';

$GLOBALS['TCA']['tt_content']['columns']['tx_c4theme_youtube_id'] = [
    'label' => 'LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:video_content.youtube_id',
    'config' => [
        'type' => 'input',
        'size' => 20,
        'max' => 20,
        'placeholder' => 'z.B. dQw4w9WgXcQ',
        'eval' => 'trim',
    ],
];

$GLOBALS['TCA']['tt_content']['types']['video_content'] = array_replace_recursive(
    $GLOBALS['TCA']['tt_content']['types']['video_content'],
    [
        'showitem' => '
            --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:general,
                --palette--;;general,
                header;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:header_formlabel,
                subheader;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:subheader_formlabel,
                image;LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:video_content.preview_image,
                tx_c4theme_youtube_id;LLL:EXT:c4theme/Resources/Private/Language/locallang_be.xlf:video_content.youtube_id,
                assets;LLL:EXT:frontend/Resources/Private/Language/locallang_ttc.xlf:asset_references,
            --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:access,
                --palette--;;visibility,
                --palette--;;access,
            --div--;LLL:EXT:core/Resources/Private/Language/Form/locallang_tabs.xlf:extended
        ',
    ]
);

<?php

declare(strict_types=1);

namespace Conrat\C4theme;

use TYPO3\CMS\Core\Imaging\IconProvider\SvgIconProvider;
use TYPO3\CMS\Core\Imaging\IconRegistry as CoreIconRegistry;
use TYPO3\CMS\Core\Utility\GeneralUtility;

/**
 * Icon Registry
 */
class IconRegistry
{
    /**
     * Register icons
     */
    public static function registerIcons(): void
    {
        $iconRegistry = GeneralUtility::makeInstance(CoreIconRegistry::class);

        $iconRegistry->registerIcon(
            'content-c4theme-video',
            SvgIconProvider::class,
            ['source' => 'EXT:c4theme/Resources/Public/Icons/ContentElements/video.svg']
        );

        $iconRegistry->registerIcon(
            'content-c4theme-team',
            SvgIconProvider::class,
            ['source' => 'EXT:c4theme/Resources/Public/Icons/ContentElements/team.svg']
        );
    }
}

<?php

/**
*  ultimateXnova
*  based on 2moons by Jan-Otto Kröpke 2009-2016
 *
 * For the full copyright and license information, please view the LICENSE
 *
 * @package ultimateXnova
 * @author Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2009 Lucky
 * @copyright 2016 Jan-Otto Kröpke <slaver7@gmail.com>
 * @copyright 2022 Koray Karakuş <koraykarakus@yahoo.com>
 * @copyright 2024 Pfahli (https://github.com/Pfahli)
 * @licence MIT
 * @version 1.8.x Koray Karakuş <koraykarakus@yahoo.com>
 * @link https://github.com/ultimateXnova/ultimateXnova
 */


class ShowTechtreePage extends AbstractGamePage
{
    public static $requireModule = MODULE_TECHTREE;

    function __construct()
    {
        parent::__construct();
    }

    function show()
    {
        global $resource, $requeriments, $reslist, $USER, $PLANET, $LNG;

        $sectionMap = array(
            'buildings' => array(
                'title' => $LNG['tech'][0],
                'elements' => $reslist['build'],
            ),
            'research' => array(
                'title' => $LNG['tech'][100],
                'elements' => $reslist['tech'],
            ),
            'fleet' => array(
                'title' => $LNG['tech'][200],
                'elements' => $reslist['fleet'],
            ),
            'defense' => array(
                'title' => $LNG['tech'][400],
                'elements' => $reslist['defense'],
            ),
            'missiles' => array(
                'title' => $LNG['tech'][500],
                'elements' => $reslist['missile'],
            ),
            'officers' => array(
                'title' => $LNG['tech'][600],
                'elements' => $reslist['officier'],
            ),
        );

        $techTreeSections = array();
        $totalEntries = 0;
        $readyEntries = 0;

        foreach ($sectionMap as $sectionKey => $sectionData)
        {
            $entries = array();

            foreach ($sectionData['elements'] as $elementId)
            {
                if (!isset($resource[$elementId])) {
                    continue;
                }

                $requirementsList = array();
                $isReady = true;

                if(isset($requeriments[$elementId]))
                {
                    foreach($requeriments[$elementId] as $requireID => $RedCount)
                    {
                        $ownCount = isset($PLANET[$resource[$requireID]]) ? $PLANET[$resource[$requireID]] : $USER[$resource[$requireID]];

                        if($ownCount < $RedCount) {
                            $isReady = false;
                        }

                        $requirementsList[$requireID] = array(
                            'count' => $RedCount,
                            'own'   => $ownCount,
                            'ready' => $ownCount >= $RedCount,
                        );
                    }
                }

                $entries[$elementId] = array(
                    'id'            => $elementId,
                    'requirements'  => $requirementsList,
                    'ready'         => $isReady,
                    'image'         => $elementId >= 600 && $elementId <= 699 ? 'jpg' : 'gif',
                );
            }

            $sectionTotal = count($entries);
            $sectionReady = 0;

            foreach ($entries as $entry) {
                if($entry['ready']) {
                    $sectionReady++;
                }
            }

            $totalEntries += $sectionTotal;
            $readyEntries += $sectionReady;

            $techTreeSections[$sectionKey] = array(
                'key' => $sectionKey,
                'title' => $sectionData['title'],
                'entries' => $entries,
                'total' => $sectionTotal,
                'ready' => $sectionReady,
            );
        }

        $this->assign(array(
            'techTreeSections'  => $techTreeSections,
            'techTreeTotal'     => $totalEntries,
            'techTreeReady'     => $readyEntries,
        ));

        $this->display('page.techTree.default.tpl');
    }
}

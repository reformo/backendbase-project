<?php

declare(strict_types=1);

namespace UnitTest\Domain\VehicleCatalog;

use Filomingo\Domain\VehicleCatalog\Services\JatoExcelParser;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PHPUnit\Framework\TestCase;

final class JatoExcelParserTest extends TestCase
{
    /**
     * @test
     */
    public function shouldParseGivenFileSuccessfully() : void
    {
        $xlsFile     = 'test/Fixtures/VehicleCatalog/jato.xlsx';
        $spreadsheet = IOFactory::load($xlsFile);
        $parser      = new JatoExcelParser();
        $this->assertInstanceOf(JatoExcelParser::class, $parser);
        $data     = $parser->parse($spreadsheet);
        $firstRow = $data->current();
        $this->assertSame('Ford Focus 4kapı sedan - 2020 1.5L TI-VCT 123PS TREND X', $firstRow['title']);
        $this->assertSame(5, $firstRow['identity']['specs']['numberOfSeats']);
        $this->assertSame('7119529', $firstRow['identity']['jatoId']);
        foreach ($data as $item) {
            $this->assertArrayHasKey('gearbox', $item['identity']['specs']);
        }
    }
}

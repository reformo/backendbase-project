<?php

declare(strict_types=1);

namespace UnitTest\Domain\Quotation;

use Filomingo\Domain\Quotation\Services\QuotationExcelParser;
use PhpOffice\PhpSpreadsheet\IOFactory;
use PHPUnit\Framework\TestCase;

final class ExcelParserTest extends TestCase
{
    /**
     * @test
     */
    public function shouldParseGivenFileSuccessfully() : void
    {
        $configFile  = 'config/backendbase/private-api/quotation-import.v1.global.php';
        $xlsFile     = 'test/Fixtures/Quotation/Importer/16527830teklifler.xls';
        $config      = require $configFile;
        $spreadsheet = IOFactory::load($xlsFile);
        $parser      = new QuotationExcelParser($config['quotation-import']);
        $this->assertInstanceOf(QuotationExcelParser::class, $parser);
        $data     = $parser->parse($spreadsheet);
        $firstRow = $data->current();
        $this->assertEquals('660065001', $firstRow['vehicleInfo']['filomingoRefId']);
        $data->next();
        $nextRow = $data->current();
        $this->assertEquals(34.96, $nextRow['quotation']['atroe']);
        $this->assertEquals(2019, $nextRow['vehicleInfo']['year']);
        $this->assertEquals(88983.45, $nextRow['quotation']['netPrice']);
    }
}

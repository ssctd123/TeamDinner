import { ApiProperty } from "@nestjs/swagger";

export class QuantityResultDto {
    @ApiProperty()
    optionId: string;
    @ApiProperty()
    quantity: number;
}
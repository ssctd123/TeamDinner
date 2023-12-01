import { ApiProperty } from "@nestjs/swagger";
import { IsPositive, IsNotEmpty, IsString } from "class-validator";

export class TeamBillDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	pollDesc: string;
	@ApiProperty()
	@IsPositive()
	amount: number;
}

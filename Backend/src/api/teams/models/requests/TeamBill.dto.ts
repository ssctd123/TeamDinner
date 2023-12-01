import { ApiProperty } from "@nestjs/swagger";
import { IsPositive } from "class-validator";

export class TeamBillDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	pollDesc: string;
	@ApiProperty()
	@IsPositive()
	amount: number;
}

import { IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class LocationCreateDto {
@ApiProperty()
@IsString()
@IsNotEmpty()
body: string;
}

import { IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class MessageCreateDto {
@ApiProperty()
@IsString()
@IsNotEmpty()
body: string;
}

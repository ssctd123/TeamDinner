import { IsEmail, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class SignupDto {
	@ApiProperty()
	@IsString()
	firstName: string;
	@ApiProperty()
	@IsString()
	lastName: string;
	@ApiProperty()
	@IsString()
	password: string;
	@ApiProperty()
	@IsEmail()
	email: string;
}

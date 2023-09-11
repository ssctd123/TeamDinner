import { IsEmail, IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { UserType } from "../../../../data/entities/User";

export class SignupDto {
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	firstName: string;
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	lastName: string;
	@ApiProperty()
	@IsString()
	@IsNotEmpty()
	password: string;
	@ApiProperty()
	@IsEmail()
	@IsNotEmpty()
	email: string;
	@ApiProperty()
	@IsNotEmpty()
	userType: UserType;
}

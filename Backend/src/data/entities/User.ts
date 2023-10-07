import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsOptional } from "class-validator";

export enum UserType {
	PLAYER = "PLAYER",
	FAMILY = "FAMILY",
}

export class User {
	@ApiProperty()
	id: string;
	@ApiProperty()
	@IsOptional()
	firstName?: string;
	@ApiPropertyOptional()
	lastName?: string;
	@ApiPropertyOptional()
	email?: string;
	@ApiPropertyOptional({ type: [String] })
	teams?: string[];
	@ApiPropertyOptional()
	venmo?: string;
	@ApiPropertyOptional()
	tipAmount?: number;
	@ApiProperty({ enum: UserType })
	userType?: UserType;
	@ApiPropertyOptional()
	deviceId?: string;
}

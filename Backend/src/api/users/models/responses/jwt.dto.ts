import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";

export class JwtDto {
	@ApiProperty()
	token: string;
	@ApiPropertyOptional()
	wasPasswordReset?: boolean;
}

import { IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";

export class Location {
    @ApiProperty()
    id: string;
    @ApiProperty()
    name: string;
    @ApiProperty()
    time: string;
    @ApiProperty()
    teamId: string;

    static fromDto(dto: LocationCreateDto, teamId: string): Poll {
		return {
			id: uuid(),
			name: dto.name,
			time: dto.time,
			team: teamId
		};
	}
}

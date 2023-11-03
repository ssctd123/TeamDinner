import { IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { uuid } from "../../utils/util";
import { LocationCreateDto } from "../../api/locations/models/requests/LocationCreate.dto";

export class Location {
    @ApiProperty()
    id: string;
    @ApiProperty()
    name: string;
    @ApiProperty()
    time: string;
    @ApiProperty()
    teamId: string;

    static fromDto(dto: LocationCreateDto, teamId: string): Location {
		return {
			id: uuid(),
			name: dto.name,
			time: dto.time,
			teamId: teamId
		};
	}
}

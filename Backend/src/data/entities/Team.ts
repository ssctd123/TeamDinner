import { Member } from "./Member";
import { ApiProperty } from "@nestjs/swagger";

export class Team {
	@ApiProperty()
	id: string;
	@ApiProperty()
	name: string;
	@ApiProperty()
	description: string;
	@ApiProperty()
	owner: string;
	@ApiProperty({ type: [String] })
	owners: string[];
	@ApiProperty({ type: [Member] })
	members: Member[];
	@ApiProperty({ type: [String] })
	invitations: string[];

	public correctLegacyProperties(): Team {
		if (owners === undefined || owners.length == 0) {
			owners = [owner];
		}
		return this;
	}
}

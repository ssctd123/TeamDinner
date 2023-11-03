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

	public function correctLegacyProperties(): Team {
		if (this.owners === undefined || this.owners.length == 0) {
			this.owners = [this.owner];
		}
		return this;
	}
}

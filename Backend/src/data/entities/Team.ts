import { Member } from "./Member";
import { ApiProperty } from "@nestjs/swagger";
import { TeamCreateDto } from "../../api/polls/models/requests/TeamCreate.dto";
import { uuid } from "../../utils/util";

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

	constructor(id: string, name: string, description: string, owner: string, owners: string[], members: Member[], invitations: string[]) {
		this.id = id;
		this.name = name;
		this.description = description;
		this.owner = owner;
		this.owners = owners;
		this.members = members;
		this.invitations = invitations;
	}
	static fromDto(dto: TeamCreateDto, ownerId: string): Team {
		return {
			id: uuid(),
			name: dto.name,
			description: dto.description,
			owner: ownerId,
			owners: [ownerId],
			members: [
				{
					id: ownerId,
					debt: 0
				}
			],
		};
	}
	public correctLegacyProperties(): Team {
		if (this.owners === undefined || this.owners.length == 0) {
			this.owners = [this.owner];
		}
		return this;
	}
}

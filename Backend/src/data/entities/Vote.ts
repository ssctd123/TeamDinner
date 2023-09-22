import { VoteDto } from "../../api/polls/models/requests/Vote.dto";
import { ApiProperty } from "@nestjs/swagger";

export class Vote {
	@ApiProperty({ type: [String] })
	optionIds: string[];
	@ApiProperty()
	userId: string;
	@ApiProperty()
	quantities?: Record<string, integer>;

	static fromDto(dto: VoteDto): Vote {
		return {
			optionIds: dto.optionIds,
			userId: dto.userId,
			quantities: dto.quantities
		};
	}
}

import { Poll } from "../../../../data/entities/Poll";
import { QuantityResult } from "QuantityResult.dto";
import { ApiProperty } from "@nestjs/swagger";

export class PollResultsDto {
	@ApiProperty()
	id: string;
	@ApiProperty({
		example: {
			option_id_1: 4,
			option_id_2: 1
		}
	})
	results: { [key: string]: number };
	quantityResults { [key: string]: QuantityResult };

	static fromPoll(poll: Poll): PollResultsDto {
		const results = {};
		const quantityResults = {};
		poll.votes.forEach((vote) => {
			vote.optionIds.forEach((optionId) => {
				if (results[optionId]) {
					results[optionId] += 1;
				} else {
					results[optionId] = 1;
				}
				quantityResults[vote.id] = {
					optionId: optionId,
					quantity: vote.quantity,
				};
			});
		});

		return {
			id: poll.id,
			results: results,
			quantityResults: quantityResults
		};
	}
}

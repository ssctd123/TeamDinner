import { IsNotEmpty, IsString } from "class-validator";
import { ApiProperty } from "@nestjs/swagger";
import { uuid } from "../../utils/util";
import { MessageCreateDto } from "../../api/messages/models/requests/MessageCreate.dto";

export class Message {
@ApiProperty()
id: string;
@ApiProperty()
body: string;
@ApiProperty()
teamId: string;
@ApiProperty()
senderName: string;

static fromDto(dto: MessageCreateDto, teamId: string, senderName: string): Message {
		return {
			id: uuid(),
			body: dto.body,
			teamId: teamId,
            senderName: senderName,
		};
	}
}

import { HttpException, HttpStatus, Injectable } from "@nestjs/common";
import { MessagesRepository } from "../../data/repositories/Firebase/messages.repository";
import { Message } from "../../data/entities/Message";
import { MessageCreateDto } from "../../api/messages/models/requests/messagecreate.dto";
import { TeamsService } from "../teams/teams.service";
import { UsersService } from "../users/users.service";
import { User } from "../../data/entities/User";


@Injectable()
export class MessagesService {
constructor(
		private messagesRepository: MessagesRepository,
        private teamsService: TeamsService,
        private usersService: UsersService
	) {}

	async createMessage(messageCreateDto: MessageCreateDto): Promise<Message> {
        const team = await this.teamsService.get();
        const user = await this.getUser();

		if (await this.isOwner()) {
			const message = Message.fromDto(messageCreateDto, team.id, user.firstName + " " + user.lastName);
			return await this.messagesRepository.createMessage(message);
		}
		throw new HttpException(
			"You are not the owner of this team",
			HttpStatus.FORBIDDEN
		);
	}

    async isOwner(): Promise<boolean> {
		const user: User = await this.usersService.getWithToken();
		return await this.teamsService.isOwner(user.id);
	}
    async getUser(): Promise<User> {
		return await this.usersService.getWithToken();
	}
}
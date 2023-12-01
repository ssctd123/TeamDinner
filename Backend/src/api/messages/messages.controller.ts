import {
    ApiBadRequestResponse,
ApiBearerAuth,
ApiCreatedResponse,
ApiForbiddenResponse,
ApiNotFoundResponse,
ApiOkResponse,
ApiOperation,
ApiQuery,
ApiTags,
ApiUnauthorizedResponse
} from "@nestjs/swagger";
import { Body, Controller, Get, Post, Query } from "@nestjs/common";
import { MessagesService } from "../../domain/messages/messages.service";
import { Message } from "../../data/entities/Message";
import { MessageCreateDto } from "./models/requests/messagecreate.dto";

@ApiBearerAuth("access-token")
@ApiTags("messages")
@Controller("messages")
export class MessagesController {
constructor(private readonly messagesService: MessagesService) {}

    @ApiOperation({ summary: "Create a new message for team" })
    @ApiCreatedResponse({ description: "Message created", type: Message })
    @ApiUnauthorizedResponse({ description: "Unauthorized JWT Token" })
    @ApiForbiddenResponse({ description: "Not owner of team" })
    @ApiNotFoundResponse({ description: "Entity not found" })
    @ApiBadRequestResponse({ description: "Invalid message" })
    @Post("create")
    async createMessage(@Body() messageCreateDto: MessageCreateDto): Promise<Message> {
        return await this.messagesService.createMessage(messageCreateDto);
    }
}
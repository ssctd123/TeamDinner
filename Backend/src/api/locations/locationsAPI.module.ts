import { Module } from "@nestjs/common";
import { LocationsController } from "./locations.controller";
import { DomainModule } from "../../domain/domain.module";

@Module({
    imports: [DomainModule],
    controllers: [LocationsController]
})
export class LocationsAPIModule {}

const {
  User,
  Actor,
  Scence,
  Character,
  ActorCharactor,
  ScenceEquipment,
  Equipment,
} = require('./index');

const bootStrap = async () => {
  const scences = await Scence.bulkCreate([
    {
      name: 'Canh 1',
      description: 'Canh Te Thien danh yeu quai',
      filmingAddress: 'Trung Quoc',
      filmingStartDate: new Date().toISOString(),
      filmingEndDate: new Date().toISOString(),
      setQuantity: 10,
    },
    {
      name: 'Canh 2',
      description: 'Canh Đường Tam Tạng giải cứu Tôn Ngộ Không',
      filmingAddress: 'Trung Quoc',
      filmingStartDate: new Date().toISOString(),
      filmingEndDate: new Date().toISOString(),
      setQuantity: 8,
    },
    {
      name: 'Canh 3',
      description: 'Canh Đường Tam Tạng gặp Bát Giới',
      filmingAddress: 'Trung Quoc',
      filmingStartDate: new Date().toISOString(),
      filmingEndDate: new Date().toISOString(),
      setQuantity: 5,
    },
  ]);
  const scence1 = await Scence.findOne({
    where: {
      name: 'Canh 1',
    },
  });
  const scence2 = await Scence.findOne({
    where: {
      name: 'Canh 2',
    },
  });
  const scence3 = await Scence.findOne({
    where: {
      name: 'Canh 3',
    },
  });
  await Character.bulkCreate([
    { name: 'Tôn Ngộ Không', ScenceId: scence1.id },
    { name: 'Đường Tăng', ScenceId: scence2.id },
    { name: 'Chu Bát Giới', ScenceId: scence2.id },
    { name: 'Sa Ngộ Tĩnh', ScenceId: scence3.id },
  ]);
  await User.bulkCreate([
    {
      username: 'actor1@gmail.com',
      password: 'actor1',
      role: 'actor',
      name: 'Ngoc Trinh',
      phone: '0987654234',
      gender: 'male',
    },
    {
      username: 'actor2@gmail.com',
      password: 'actor2',
      role: 'actor',
      name: 'Thay Ba',
      phone: '0987654234',
      gender: 'female',
    },
    {
      username: 'admin@gmail.com',
      password: 'admin',
      role: 'admin',
      name: 'Hung Bui',
      phone: '0987654234',
      gender: 'male',
    },
  ]);
  // // ACTOR
  const user1 = await User.findOne({
    where: {
      name: 'Hung Bui',
    },
  });
  const user2 = await User.findOne({
    where: {
      name: 'Thay Ba',
    },
  });
  const user3 = await User.findOne({
    where: {
      name: 'Ngoc Trinh',
    },
  });
  await Actor.bulkCreate([
    {
      description: 'Americian Actor',
      imageURL: 'https://www.gstatic.com/tv/thumb/persons/435/435_v9_bc.jpg',
      UserId: user1.id,
    },
    {
      description: 'Teacher Three',
      imageURL: 'https://nguoinoitieng.tv/images/nnt/100/0/beoj.jpg',
      UserId: user2.id,
    },
    {
      description: 'Ngoc Trinh',
      imageURL:
        'https://media.congluan.vn/files/thanhduyen/2020/05/01/ngoc-trinh-lay-chong-1231.jpg',
      UserId: user3.id,
    },
  ]);

  const actor1Id = await Actor.findOne({
    where: {
      UserId: user2.id,
    },
  });
  const actor2Id = await Actor.findOne({
    where: {
      UserId: user3.id,
    },
  });

  console.log('actor1Id.id, actor2Id.id', actor1Id.id, actor2Id.id);

  const character1 = await Character.findOne({
    where: {
      name: 'Tôn Ngộ Không',
    },
  });
  const character2 = await Character.findOne({
    where: {
      name: 'Đường Tăng',
    },
  });
  const character3 = await Character.findOne({
    where: {
      name: 'Chu Bát Giới',
    },
  });
  const character4 = await Character.findOne({
    where: {
      name: 'Sa Ngộ Tĩnh',
    },
  });

  await ActorCharactor.bulkCreate([
    // { ActorId: 4, CharacterId: 1 },
    // { ActorId: 4, CharacterId: 3 },
    // { ActorId: 5, CharacterId: 1 },
    // { ActorId: 5, CharacterId: 4 },
    { ActorId: actor1Id.id, CharacterId: character1.id },
    { ActorId: actor1Id.id, CharacterId: character3.id },
    { ActorId: actor1Id.id, CharacterId: character2.id },
    { ActorId: actor2Id.id, CharacterId: character1.id },
    { ActorId: actor2Id.id, CharacterId: character4.id },
  ]);

  // const equipments = await Equipment.bulkCreate([
  //   {
  //     name: 'Clapper board',
  //     description: 'Clapper board',
  //     imageURL:
  //       'https://images-na.ssl-images-amazon.com/images/I/717BJL9gAAL._AC_SL1500_.jpg',
  //     status: 'available',
  //     quantity: 5,
  //     isDeleted: false,
  //   },
  //   {
  //     name: 'Máy quay phim',
  //     description: 'Máy quay phim',
  //     imageURL:
  //       'https://lh3.googleusercontent.com/proxy/EDeDWF5UZZa1rMdN-oX0qcNBRUNZOuodVKIHKEP_IYhTujuN7O-PCmmtLtG7hjy3mp1PUx12z9JCMqbndHjiMNceTOydLVfsmgDgW3zUghnKaVXX_dFCIw',
  //     status: 'unavailable',
  //     quantity: 10,
  //   },
  // ]);

  // console.log('equipments', equipments);

  // await ScenceEquipment.bulkCreate([
  //   { ScenceId: scences[0].id, EquipmentId: equipments[0].id },
  //   { ScenceId: scences[1].id, EquipmentId: equipments[0].id },
  //   { ScenceId: scences[2].id, EquipmentId: equipments[1].id },
  // ]);
};

module.exports = bootStrap;

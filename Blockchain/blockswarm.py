import hashlib
from datetime import datetime

class Block:
    prev_hash = None
    current_hash = None
    nonce = -1

    timestamp = None

    data = None
    
    def __init__(self, prev_hash, data):
        self.prev_hash = prev_hash
        self.data = data
        self.timestamp = datetime.timestamp(datetime.now())

    def __repr__(self):
        return f"Block {self.current_hash} (prev: {self.prev_hash})"
    
    @property
    def block_string(self):
        return f"{self.prev_hash}-{self.data}-{self.nonce}"

    def hash(self):
        return hashlib.sha256(bytes(self.block_string, "utf-8")).hexdigest()

    def mine(self, difficulty):
        found = False
        while not found:
            self.nonce += 1
            self.current_hash = self.hash()
            if self.current_hash[0:difficulty] == "0" * difficulty:
                found = True
class Blockchain:
    blocks = []
    difficulty = 4

    def add(self, block):
        block.mine(self.difficulty)
        self.blocks.append(block)
        self.validate()

    @property
    def last_block(self):
        return self.blocks[-1] if len(self.blocks) else None

    def build_block(self, data):
        if self.last_block:
            block = Block(self.last_block.current_hash, data)
            self.add(block)
        else:
            raise Exception("Missing Genesis block")

    def validate(self):
        for i in range(len(self.blocks)):
            if i > 1 and self.blocks[i].prev_hash != self.blocks[i-1].current_hash:
                raise Exception("Blockchain not Coherent")

# Populate Blockchain with generic data
chain = Blockchain()
block = Block(None, "GENESIS")

chain.add(block)
chain.build_block("Mari hat Bild 1")
chain.build_block("John hat Bild 2")
chain.build_block("Bob hat Bild 3")
chain.build_block("Kevin hat Bild 4")
chain.build_block("Lisa hat Bild 5")
chain.build_block("Natalie hat Bild 6")